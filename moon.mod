// Learn more about moon.mod configuration:
// https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html
//
// To add a dependency, run this command in your terminal:
//   moon add moonbitlang/x
//
// Or manually declare it in `import`, for example:
// import {
//   "moonbitlang/x@0.4.6",
// }

name = "KAINAproject/kaguya"

version = "0.1.0"

readme = "README.mbt.md"

repository = ""

license = "Apache-2.0"

keywords = [ ]

preferred_target = "js"

description = ""

import {
  "moonbitlang/async@0.21.3",
  "mizchi/three@0.1.3",
  "mizchi/js_browser@0.13.0",
  "mizchi/js_core@0.13.0",
}
