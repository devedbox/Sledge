// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sledge",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Sledge",
            targets: ["Sledge"]),
        .library(
            name: "SemVer",
            targets: ["SemVer"]),
        .library(
            name: "SafeAccessible",
            targets: ["SafeAccessible"]),
        .library(
            name: "Generator",
            targets: ["Generator"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Sledge",
            dependencies: []),
        .target(
            name: "SemVer",
            dependencies: [],
            path: "Sources/SemVer"),
        .target(
            name: "SafeAccessible",
            dependencies: [],
            path: "Sources/SafeAccessible"),
        .target(
            name: "Generator",
            dependencies: [],
            path: "Sources/Generator"),
        .testTarget(
            name: "SledgeTests",
            dependencies: ["Sledge"]),
        .testTarget(
            name: "SafeAccessibleTests",
            dependencies: ["SafeAccessible"],
            path: "Tests/SafeAccessibleTests"),
        .testTarget(
            name: "GeneratorTests",
            dependencies: ["Generator"],
            path: "Tests/GeneratorTests"),
    ]
)
