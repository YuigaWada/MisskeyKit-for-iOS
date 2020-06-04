// swift-tools-version:5.1
//
//  Package.Swift
//  MisskeyKit
//
import PackageDescription

let package = Package(
    name: "MisskeyKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "MisskeyKit", targets: ["MisskeyKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream", from: "3.0.0")
    ],
    targets: [
        .target(name: "MisskeyKit", dependencies: ["Starscream"], path: "MisskeyKit")
    ]
)
