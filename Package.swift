// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "StringeeWidget",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "StringeeWidget",
            targets: [
                "StringeeWidget",
                "StringeeWidgetDependencyBridge"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/stringeecom/Stringee-iOS-SDK-SPM",
            exact: "2.0.3"
        )
    ],
    targets: [
        .binaryTarget(
            name: "StringeeWidget",
            url: "https://github.com/stringeecom/StringeeWidget-iOS/releases/download/0.2.2/StringeeWidget.xcframework.zip",
            checksum: "7c4a8fad856ec53741ced9837667120a1fee2c7d00b04cdf38ee4a60f9bfe3e0"
        ),
        .target(
            name: "StringeeWidgetDependencyBridge",
            dependencies: [
                .product(name: "Stringee", package: "Stringee-iOS-SDK-SPM")
            ],
            path: "Sources/StringeeWidgetDependencyBridge"
        )
    ]
)
