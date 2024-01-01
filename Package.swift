// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "lml",
  platforms: [.macOS(.v13)],
  products: [
    .library(name: "ImageTransformation", targets: ["ImageTransformation"]),
  ],
  targets: [
    .target(
      name: "ImageTransformation"
    ),
    .testTarget(
      name: "ImageTransformationTests",
      dependencies: ["ImageTransformation"]
    ),
  ]
)
