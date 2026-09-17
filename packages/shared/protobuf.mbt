///|
const WIRE_VARINT : Int = 0

///|
const WIRE_LENGTH_DELIMITED : Int = 2

///|
const WIRE_FIXED32 : Int = 5

///|
priv struct ProtoWriter {
  buffer : @buffer.Buffer
}

///|
fn ProtoWriter::new() -> ProtoWriter {
  { buffer: @buffer.Buffer(), }
}

///|
fn ProtoWriter::write_key(
  self : ProtoWriter,
  field_number : Int,
  wire_type : Int,
) -> Unit {
  self.write_varint(((field_number << 3) | wire_type).to_uint64())
}

///|
fn ProtoWriter::write_varint(self : ProtoWriter, value : UInt64) -> Unit {
  let mut current = value
  while current >= 0x80UL {
    self.buffer.write_byte(((current & 0x7FUL) | 0x80UL).to_byte())
    current = current >> 7
  }
  self.buffer.write_byte(current.to_byte())
}

///|
fn ProtoWriter::write_uint32(
  self : ProtoWriter,
  field_number : Int,
  value : UInt,
) -> Unit {
  self.write_key(field_number, WIRE_VARINT)
  self.write_varint(value.to_uint64())
}

///|
fn ProtoWriter::write_uint64(
  self : ProtoWriter,
  field_number : Int,
  value : UInt64,
) -> Unit {
  self.write_key(field_number, WIRE_VARINT)
  self.write_varint(value)
}

///|
fn ProtoWriter::write_float(
  self : ProtoWriter,
  field_number : Int,
  value : Float,
) -> Unit {
  self.write_key(field_number, WIRE_FIXED32)
  self.write_raw_float(value)
}

///|
fn ProtoWriter::write_raw_float(self : ProtoWriter, value : Float) -> Unit {
  self.buffer.write_uint_le(value.reinterpret_as_uint())
}

///|
fn ProtoWriter::write_packed_floats(
  self : ProtoWriter,
  field_number : Int,
  values : Array[Float],
) -> Unit {
  let values_writer = ProtoWriter::new()
  for value in values {
    values_writer.write_raw_float(value)
  }
  self.write_bytes(field_number, values_writer.finish())
}

///|
fn ProtoWriter::write_string(
  self : ProtoWriter,
  field_number : Int,
  value : String,
) -> Unit {
  let bytes = @utf8.encode(value)
  self.write_bytes(field_number, bytes)
}

///|
fn ProtoWriter::write_bytes(
  self : ProtoWriter,
  field_number : Int,
  value : Bytes,
) -> Unit {
  self.write_key(field_number, WIRE_LENGTH_DELIMITED)
  self.write_varint(value.length().to_uint64())
  self.buffer.write_bytes(value[:])
}

///|
fn ProtoWriter::write_message(
  self : ProtoWriter,
  field_number : Int,
  value : Bytes,
) -> Unit {
  self.write_bytes(field_number, value)
}

///|
fn ProtoWriter::finish(self : ProtoWriter) -> Bytes {
  self.buffer.to_bytes()
}

///|
priv struct ProtoReader {
  bytes : Bytes
  mut position : Int
}

///|
fn ProtoReader::new(bytes : Bytes) -> ProtoReader {
  { bytes, position: 0, }
}

///|
fn ProtoReader::read_byte(self : ProtoReader) -> Result[Byte, String] {
  if self.position >= self.bytes.length() {
    Err("unexpected end of protobuf input")
  } else {
    let byte = self.bytes[self.position]
    self.position += 1
    Ok(byte)
  }
}

///|
fn ProtoReader::read_varint(self : ProtoReader) -> Result[UInt64, String] {
  let mut result : UInt64 = 0UL
  let mut shift = 0
  while shift < 64 {
    let byte = match self.read_byte() {
      Ok(byte) => byte
      Err(error) => return Err(error)
    }
    let bits = byte.to_uint64() & 0x7FUL
    result = result | (bits << shift)
    if (byte.to_uint() & 0x80U) == 0U {
      return Ok(result)
    }
    shift += 7
  }
  Err("protobuf varint is too long")
}

///|
fn ProtoReader::read_key(self : ProtoReader) -> Result[(Int, Int), String] {
  let raw = match self.read_varint() {
    Ok(value) => value
    Err(error) => return Err(error)
  }
  let field_number = (raw >> 3).to_int()
  let wire_type = (raw & 0x7UL).to_int()
  if field_number <= 0 {
    Err("protobuf field number must be positive")
  } else {
    Ok((field_number, wire_type))
  }
}

///|
fn ProtoReader::read_uint32(self : ProtoReader) -> Result[UInt, String] {
  match self.read_varint() {
    Ok(value) => Ok(value.to_uint())
    Err(error) => Err(error)
  }
}

///|
fn ProtoReader::read_uint64(self : ProtoReader) -> Result[UInt64, String] {
  self.read_varint()
}

///|
fn ProtoReader::read_fixed32(self : ProtoReader) -> Result[UInt, String] {
  if self.position + 4 > self.bytes.length() {
    return Err("unexpected end of protobuf fixed32")
  }
  let value = self.bytes[self.position].to_uint() |
    (self.bytes[self.position + 1].to_uint() << 8) |
    (self.bytes[self.position + 2].to_uint() << 16) |
    (self.bytes[self.position + 3].to_uint() << 24)
  self.position += 4
  Ok(value)
}

///|
fn ProtoReader::read_float(self : ProtoReader) -> Result[Float, String] {
  match self.read_fixed32() {
    Ok(value) => Ok(Float::reinterpret_from_uint(value))
    Err(error) => Err(error)
  }
}

///|
fn ProtoReader::read_packed_floats(
  self : ProtoReader,
) -> Result[Array[Float], String] {
  let bytes = match self.read_bytes() {
    Ok(value) => value
    Err(error) => return Err(error)
  }
  if bytes.length() % 4 != 0 {
    return Err("packed protobuf float field has an invalid length")
  }
  let reader = ProtoReader::new(bytes)
  let values : Array[Float] = []
  while reader.position < reader.bytes.length() {
    match reader.read_float() {
      Ok(value) => values.push(value)
      Err(error) => return Err(error)
    }
  }
  Ok(values)
}

///|
fn ProtoReader::read_bytes(self : ProtoReader) -> Result[Bytes, String] {
  let length = match self.read_varint() {
    Ok(value) => value.to_int()
    Err(error) => return Err(error)
  }
  if length < 0 || self.position + length > self.bytes.length() {
    return Err("protobuf length-delimited field is out of bounds")
  }
  let value = Bytes::from_iter(
    self.bytes[self.position:self.position + length].iter(),
  )
  self.position += length
  Ok(value)
}

///|
fn ProtoReader::read_string(self : ProtoReader) -> Result[String, String] {
  match self.read_bytes() {
    Ok(value) => Ok(@utf8.decode_lossy(value[:]))
    Err(error) => Err(error)
  }
}

///|
fn ProtoReader::skip(
  self : ProtoReader,
  wire_type : Int,
) -> Result[Unit, String] {
  match wire_type {
    0 =>
      match self.read_varint() {
        Ok(_) => Ok(())
        Err(error) => Err(error)
      }
    1 =>
      if self.position + 8 > self.bytes.length() {
        Err("unexpected end of protobuf fixed64")
      } else {
        self.position += 8
        Ok(())
      }
    2 =>
      match self.read_bytes() {
        Ok(_) => Ok(())
        Err(error) => Err(error)
      }
    5 =>
      if self.position + 4 > self.bytes.length() {
        Err("unexpected end of protobuf fixed32")
      } else {
        self.position += 4
        Ok(())
      }
    _ => Err("unsupported protobuf wire type")
  }
}
