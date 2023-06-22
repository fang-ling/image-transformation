// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "lml",
  products: [
    .library(
      name: "lml",
      targets: ["lml"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/fang-ling/image-codec", from: "0.0.12")
  ],
  targets: [
    .target(
      name: "lml",
      dependencies: [.product(name: "ImageCodec", package: "image-codec")]
    ),
    .testTarget(
      name: "lmlTests",
      dependencies: ["lml"]
    ),
  ]
)
