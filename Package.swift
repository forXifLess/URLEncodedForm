// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "URLEncodedForm",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "URLEncodedForm",
      targets: ["URLEncodedForm"]),
  ],
  dependencies: [
    .package(url: "https://github.com/airbnb/swift", from: "1.0.5"),
  ],
  targets: [
    .target(
      name: "URLEncodedForm",
      dependencies: []),
    .testTarget(
      name: "URLEncodedFormTests",
      dependencies: ["URLEncodedForm"]),
  ])
