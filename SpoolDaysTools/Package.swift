// swift-tools-version: 6.1.2
import PackageDescription

let package = Package(
    name: "SpoolDaysTools",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "SpoolDaysTools",
            targets: ["SpoolDaysTools"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/mono0926/LicensePlist.git", exact: "3.27.9")
    ],
    targets: [
        .target(
            name: "SpoolDaysTools",
            dependencies: []
        )
    ]
)
