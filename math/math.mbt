///|
pub struct Vec3 {
  x : Double
  y : Double
  z : Double
}

///|
pub fn Vec3::new(x : Double, y : Double, z : Double) -> Vec3 {
  { x, y, z, }
}

///|
pub fn Vec3::add(self : Vec3, other : Vec3) -> Vec3 {
  { x: self.x + other.x, y: self.y + other.y, z: self.z + other.z, }
}

///|
pub fn Vec3::sub(self : Vec3, other : Vec3) -> Vec3 {
  { x: self.x - other.x, y: self.y - other.y, z: self.z - other.z, }
}

///|
pub fn Vec3::scale(self : Vec3, scalar : Double) -> Vec3 {
  { x: self.x * scalar, y: self.y * scalar, z: self.z * scalar, }
}

///|
pub fn Vec3::dot(self : Vec3, other : Vec3) -> Double {
  self.x * other.x + self.y * other.y + self.z * other.z
}

///|
pub fn Vec3::cross(self : Vec3, other : Vec3) -> Vec3 {
  {
    x: self.y * other.z - self.z * other.y,
    y: self.z * other.x - self.x * other.z,
    z: self.x * other.y - self.y * other.x,
  }
}

///|
pub fn Vec3::length(self : Vec3) -> Double {
  self.dot(self).sqrt()
}

///|
pub fn Vec3::normalize(self : Vec3) -> Vec3 {
  let length = self.length()
  if length == 0.0 {
    Vec3::new(0.0, 0.0, 0.0)
  } else {
    self.scale(1.0 / length)
  }
}

///|
pub struct Mat4 {
  priv values : Array[Double]
}

///|
fn Mat4::from_values(values : Array[Double]) -> Mat4 {
  { values, }
}

///|
pub fn Mat4::identity() -> Mat4 {
  Mat4::from_values([
    1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0,
  ])
}

///|
pub fn Mat4::translation(x : Double, y : Double, z : Double) -> Mat4 {
  Mat4::from_values([
    1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, x, y, z, 1.0,
  ])
}

///|
pub fn Mat4::rotation_y(angle : Double) -> Mat4 {
  let c = @coremath.cos(angle)
  let s = @coremath.sin(angle)
  Mat4::from_values([
    c,
    0.0,
    -s,
    0.0,
    0.0,
    1.0,
    0.0,
    0.0,
    s,
    0.0,
    c,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
  ])
}

///|
pub fn Mat4::perspective(
  fov_y : Double,
  aspect : Double,
  near : Double,
  far : Double,
) -> Mat4 {
  let f = 1.0 / @coremath.tan(fov_y / 2.0)
  let range_inverse = 1.0 / (near - far)
  Mat4::from_values([
    f / aspect,
    0.0,
    0.0,
    0.0,
    0.0,
    f,
    0.0,
    0.0,
    0.0,
    0.0,
    far * range_inverse,
    -1.0,
    0.0,
    0.0,
    far * near * range_inverse,
    0.0,
  ])
}

///|
pub fn Mat4::mul(self : Mat4, other : Mat4) -> Mat4 {
  let result = Array::make(16, 0.0)
  for column = 0; column < 4; column = column + 1 {
    for row = 0; row < 4; row = row + 1 {
      let mut value = 0.0
      for index = 0; index < 4; index = index + 1 {
        value = value +
          self.values[index * 4 + row] * other.values[column * 4 + index]
      }
      result[column * 4 + row] = value
    }
  }
  Mat4::from_values(result)
}

///|
pub fn Mat4::to_fixed_array(self : Mat4) -> FixedArray[Double] {
  FixedArray::makei(self.values.length(), fn(i) { self.values[i] })
}

///|
pub fn Mat4::transform_point(self : Mat4, point : Vec3) -> Vec3 {
  let x = self.values[0] * point.x +
    self.values[4] * point.y +
    self.values[8] * point.z +
    self.values[12]
  let y = self.values[1] * point.x +
    self.values[5] * point.y +
    self.values[9] * point.z +
    self.values[13]
  let z = self.values[2] * point.x +
    self.values[6] * point.y +
    self.values[10] * point.z +
    self.values[14]
  let w = self.values[3] * point.x +
    self.values[7] * point.y +
    self.values[11] * point.z +
    self.values[15]
  if w == 0.0 {
    Vec3::new(x, y, z)
  } else {
    Vec3::new(x / w, y / w, z / w)
  }
}
