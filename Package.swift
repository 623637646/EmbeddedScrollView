// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EmbeddedScrollView",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EmbeddedScrollView",
            targets: ["EmbeddedScrollView"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "SwiftHook", url: "https://github.com/623637646/SwiftHook.git", "3.3.0"..<"4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        // Source Code
        .target(
            name: "EmbeddedScrollView",
            dependencies: ["SwiftHook"],
            path: "EmbeddedScrollView",
            exclude: ["EmbeddedScrollView.h", "Info.plist"]),
    ]
)
