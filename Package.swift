import PackageDescription

let package = Package(
    name: "ConfigFile"
    dependencies: [
        .Package(url: "https://github.com/smud/LinuxCompatibility.git", majorVersion: 0),
    ]
)
