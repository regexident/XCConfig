//
//  XCConfigTests.swift
//  XCConfigTests
//
//  Created by Vincent Esche on 6/9/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Cocoa
import XCTest

import XCConfig

class XCConfigTests: XCTestCase {
	
	let parser = XCConfigParser()
	
	func testIncludesParsing() {
		let string =
		"// #include \"foo.xcconfig\"\n" +
		"#include \"bar.xcconfig\""
		XCTAssertEqual(self.parser.parseIncludes(string), ["bar.xcconfig"])
	}
	
    func testAttributesParsing() {
		let string =
		"// FOO = NO\n" +
		"FOO_BAR = $(inherited) Lorem\\ Ipsum Dolor\\ Sit\\ Amet"
		 XCTAssertEqual(self.parser.parseAttributes(string), ["FOO_BAR": ["$(inherited)", "Lorem Ipsum", "Dolor Sit Amet"]])
	}
	
	func testAttributeArrayParsing() {
		let string = "$(inherited) 'Some/Quoted\\ Path' /Some/Custom\\ Path/"
		XCTAssertEqual(self.parser.parseValues(string), ["$(inherited)", "Some/Quoted\\ Path", "/Some/Custom Path/"])
	}
	
	func testParsing() {
		let bundle = NSBundle(forClass: XCConfigTests.self)
		let filePath = bundle.pathForResource("UniversalFramework_Framework", ofType: "xcconfig")!
		let fileURL = NSURL(fileURLWithPath: filePath)
		let attributes: [String:[String]] = [
			"CODE_SIGN_IDENTITY[sdk=iphoneos*]": ["iPhone", "Developer"],
			"COMBINE_HIDPI_IMAGES[sdk=macosx*]": ["YES"],
			"FRAMEWORK_SEARCH_PATHS[sdk=iphoneos*]": ["$(inherited)", "$(SDKROOT)/System/Library/Frameworks"],
			"FRAMEWORK_SEARCH_PATHS[sdk=iphonesimulator*]": ["$(inherited)", "$(SDKROOT)/System/Library/Frameworks"],
			"FRAMEWORK_SEARCH_PATHS[sdk=macosx*]": ["$(inherited)", "$(DEVELOPER_FRAMEWORKS_DIR)"],
			"FRAMEWORK_VERSION[sdk=macosx*]": ["A"],
			"LD_RUNPATH_SEARCH_PATHS[sdk=iphoneos*]": ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"],
			"LD_RUNPATH_SEARCH_PATHS[sdk=iphonesimulator*]": ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"],
			"LD_RUNPATH_SEARCH_PATHS[sdk=macosx*]": ["$(inherited)", "@executable_path/../Frameworks", "@loader_path/Frameworks"],
			"SUPPORTED_PLATFORMS": ["iphonesimulator", "iphoneos", "macosx"],
			"TARGETED_DEVICE_FAMILY[sdk=iphone*]": ["1,2"],
			"TARGETED_DEVICE_FAMILY[sdk=iphonesimulator*]": ["1,2"],
			"VALID_ARCHS[sdk=iphoneos*]": ["arm64", "armv7", "armv7s"],
			"VALID_ARCHS[sdk=iphonesimulator*]": ["arm64", "armv7", "armv7s"],
			"VALID_ARCHS[sdk=macosx*]": ["i386", "x86_64"],
		]
		if let xcconfig = XCConfig(fileURL: fileURL!) {
			let keys = Set<String>(attributes.keys)
			XCTAssertEqual(Set<String>(xcconfig.attributes.keys), keys)
			for key in keys {
				XCTAssertEqual(attributes[key]!, xcconfig.attributes[key]!)
			}
		} else {
			XCTFail("Could not read file.")
		}
	}
	
}
