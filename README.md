# XCConfig

**XCConfig** is a simple Swift implementation of a parser for `.xcconfig` files.

## Features

It parses `.xcconfig` files (resolving includes if necessary). Nothing more, nothing less.

## Usage

```swift
let fileURL = NSURL(fileURLWithPath: ...)
if let xcconfig = XCConfig(fileURL: fileURL!) {
	let attributes: [String:[String]] = xcconfig.attributes
}
```

Also included is a command-line tool called `xccfg` that reads `.xcconfig` files and prints out their attributes merged with their includes. Very handy for inspecting build configurations.

## Installation

Just copy the files in `"XCConfig/Classes/..."` into your project.

Alternatively you can install **XCConfig** into your project with [Carthage](https://github.com/Carthage/Carthage).

## Swift

**XCConfig** is implemented in **Swift**.

## Dependencies

None.

## Creator

Vincent Esche ([@regexident](http://twitter.com/regexident))

## License

**XCConfig** is available under a **modified BSD-3 clause license** with the **additional requirement of attribution**. See the `LICENSE` file for more info.