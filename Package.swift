// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "ChromaColorPicker",
    // platforms: [.iOS("8.0")],
    products: [
        .library(name: "ChromaColorPicker", targets: ["ChromaColorPicker"])
    ],
    targets: [
        .target(
            name: "ChromaColorPicker",
            path: "ChromaColorPicker"
        )
    ]
)
