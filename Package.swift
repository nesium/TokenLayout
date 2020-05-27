// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "TokenLayout",
  products: [.library(name: "TokenLayout", targets: ["TokenLayout"])],
  targets: [
    .target(name: "TokenLayout", dependencies: []),
    .testTarget(name: "TokenLayoutTests", dependencies: ["TokenLayout"]),
  ]
)
