// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "EasyTipView",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "EasyTipView",
            targets: ["EasyTipView"])
    ],
    targets: [
        .target(
            name: "EasyTipView",
            path: "Source"),
        .testTarget(
            name: "EasyTipViewTests",
            dependencies: [
                "EasyTipView"
            ],
            path: "Tests")
    ]
)