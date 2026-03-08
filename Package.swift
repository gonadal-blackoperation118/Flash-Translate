// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FlashTranslate",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "FlashTranslate", targets: ["FlashTranslate"])
    ],
    targets: [
        .executableTarget(
            name: "FlashTranslate",
            path: ".",
            exclude: [
                "Tests",
                "memory",
                "Info.plist",
                "log.md"
            ],
            sources: [
                "FlashTranslateApp.swift",
                "Sources"
            ]
        ),
        .testTarget(
            name: "FlashTranslateTests",
            dependencies: ["FlashTranslate"],
            path: "Tests"
        )
    ]
)
