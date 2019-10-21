// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MXParallaxHeader",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "MXParallaxHeader",
                 targets: ["MXParallaxHeader"])
    ],
    targets: [
        .target(
            name: "MXSegmentedPager",
            path: "MXParallaxHeader"
        )
    ],
    swiftLanguageVersions: [.v5,.v4]
)
