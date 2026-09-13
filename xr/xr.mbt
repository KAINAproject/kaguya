///|
pub struct View {
  priv eye : String
  priv projection_matrix : Array[Double]
  priv view_matrix : Array[Double]
}

///|
pub fn View::new(
  eye : String,
  projection_matrix : Array[Double],
  view_matrix : Array[Double],
) -> View {
  { eye, projection_matrix, view_matrix, }
}

///|
pub fn View::eye(self : View) -> String {
  self.eye
}

///|
pub fn View::projection_matrix(self : View) -> Array[Double] {
  self.projection_matrix
}

///|
pub fn View::view_matrix(self : View) -> Array[Double] {
  self.view_matrix
}

///|
pub struct ViewerPose {
  priv views : Array[View]
}

///|
pub fn ViewerPose::new(views : Array[View]) -> ViewerPose {
  { views, }
}

///|
pub fn ViewerPose::view_count(self : ViewerPose) -> Int {
  self.views.length()
}

///|
pub fn ViewerPose::view(self : ViewerPose, index : Int) -> View {
  self.views[index]
}
