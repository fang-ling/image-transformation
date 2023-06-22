// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "lml",
  products: [
    .library(name: "ImageTransformation", targets: ["ImageTransformation"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/fang-ling/image-intermedia",
      from: "0.0.1"
    )
  ],
  targets: [
    .target(
      name: "ImageTransformation",
      dependencies: [
        .product(name: "ImageIntermedia", package: "image-intermedia")
      ]
    ),
    .testTarget(
      name: "ImageTransformationTests",
      dependencies: ["ImageTransformation"]
    ),
  ]
)
