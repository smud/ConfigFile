import PackageDescription

let package = Package(
    name: "ConfigFile",
    dependencies: [
        .Package(url: "https://github.com/smud/Utils.git", majorVersion: 1),
    ]
)
