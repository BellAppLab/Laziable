// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "Laziable",
    products: [
        .library(name: "Laziable",
                 targets: ["Laziable"]),
        ],
    targets: [
        .target(
            name: "Laziable"
        ),
        .testTarget(
            name: "LaziableTests",
            dependencies: ["Laziable"]
        ),
    ],
    swiftLanguageVersions: [3, 4]
)
