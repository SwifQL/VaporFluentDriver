<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
    <img src="https://img.shields.io/github/workflow/status/MihaelIsaev/SwifQLVapor/test" alt="Github Actions">
</p>

# SwifQLVapor

Additional lib for SwifQL library

## Installation

```swift
.package(url: "https://github.com/MihaelIsaev/SwifQL.git", from:"1.0.0"),
.package(url: "https://github.com/MihaelIsaev/SwifQLVapor.git", from:"1.0.0"),
```
In your target's dependencies add `"SwifQL"` and `"SwifQLVapor"`, e.g. like this:
```swift
.target(name: "App", dependencies: ["Vapor", "SwifQL", "SwifQLVapor"]),
```
