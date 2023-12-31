// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "lml",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "ImageTransformation", targets: ["ImageTransformation"]),
  ],
  dependencies: [
    .package(url: "https://github.com/fang-ling/image-codec", from: "0.0.21"),
  ],
  targets: [
    .target(
      name: "ImageTransformation"
    ),
    .testTarget(
      name: "ImageTransformationTests",
      dependencies: [
        "ImageTransformation",
        .product(name: "ImageCodec", package: "image-codec")
      ]
    ),
  ]
)
