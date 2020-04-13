// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ChromaColorPicker",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "ChromaColorPicker",
            targets: ["ChromaColorPicker"]
        )
    ],
    targets: [
        .target(
            name: "ChromaColorPicker",
            path: "Source"
        ),
        .testTarget(
            name: "ChromaColorPickerTests",
            dependencies: ["ChromaColorPicker"],
            path: "Tests"
        )
    ]
)
