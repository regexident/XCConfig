//
//  main.swift
//  xccfg
//
//  Created by Vincent Esche on 6/21/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Foundation

func printHelp(filePath: String) {
	println("usage: \(filePath.lastPathComponent) FILE.xcconfig")
}

let arguments = Process.arguments

if (arguments.count != 2) || (arguments[1] == "--help") || (arguments[1] == "-h") {
	printHelp(arguments[0])
} else {
	let parser = XCConfigParser()
	let filePath = arguments[1]
	let fileURL = NSURL(fileURLWithPath: filePath)
	if let xcconfig = XCConfig(fileURL: fileURL!) {
		println(xcconfig)
	} else {
		println("Could not read file.")
	}
}
