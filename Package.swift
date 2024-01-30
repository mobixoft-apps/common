// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Common",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "Common",
      targets: ["Common"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
    .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.19.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.20.0"),
    .package(url: "https://github.com/mobixoft-apps/SwiftPlus", branch: "main")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Common",
      dependencies:[
        .product(name: "Alamofire", package: "Alamofire"),
        .product(name: "Sentry", package: "sentry-cocoa"),
        .product(name: "SwiftPlus", package: "SwiftPlus"),
        .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
        .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
      ]),
    .testTarget(
      name: "CommonTests",
      dependencies: ["Common"]),
  ]
)
