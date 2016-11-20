import PackageDescription

let package = Package(
    name: "ConfigFile",
    dependencies: [
        .Package(url: "https://github.com/smud/StringUtils.git", majorVersion: 1),
        .Package(url: "https://github.com/smud/CollectionUtils.git", majorVersion: 1),
        .Package(url: "https://github.com/smud/ScannerUtils.git", majorVersion: 1),
    ]
)
