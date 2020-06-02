import PackageDescription

let package = Package(
    name: "RxPagingKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "RxPagingKit", targets: ["RxPagingKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git"),
        .package(url: "https://github.com/kazuhiro4949/PagingKit.git"),
    ],
    targets: [
        .target(
            name: "RxPagingKit",
            path: "RxPagingKit",
            dependencies: ["RxSwift", "PagingKit"]),
        .testTarget(
            name: "RxPagingKitTests",
            path: "RxPagingKitTests",
            dependencies: ["RxPagingKit"]),
    ]
)
