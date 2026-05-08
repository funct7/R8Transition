// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "R8Transition",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "R8Transition",
            targets: ["R8Transition"]
        ),
    ],
    targets: [
        .target(
            name: "R8Transition",
            path: "R8Transition",
            sources: [
                "Type",
                "Extension",
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
