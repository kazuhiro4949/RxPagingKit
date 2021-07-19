// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RxPagingKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "RxPagingKit", targets: ["RxPagingKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/kazuhiro4949/PagingKit.git", .upToNextMajor(from: "1.18.0"))
    ],
    targets: [
        .target(name: "RxPagingKit", dependencies: ["RxSwift", "RxCocoa", "PagingKit"], path: "RxPagingKit")
    ],
    swiftLanguageVersions: [.v5]
)
