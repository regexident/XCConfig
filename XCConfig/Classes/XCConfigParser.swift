//
//  XCConfigParser.swift
//  XCConfig
//
//  Created by Vincent Esche on 6/9/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Foundation

public class XCConfigParser {
	
	private let includesRegex = NSRegularExpression(pattern: "^\\s*#include\\s+\"([^\"]+)\"", options: NSRegularExpressionOptions.AnchorsMatchLines, error: nil)!
	private let attributesRegex = NSRegularExpression(pattern: "^\\s*(\\w+?(?:\\[.+?\\])?)\\s*=\\s*([^\\n]+?)\\s*?(?://|$)", options: NSRegularExpressionOptions.AnchorsMatchLines, error: nil)!
	private let valuesRegex = NSRegularExpression(pattern: "(?<!\\\\)\\s+", options: NSRegularExpressionOptions(), error: nil)!
	
	public init() {
		
	}
	
	public func parseIncludes(string: String) -> [String] {
		let nsString = string as NSString
		let range = NSRange(location: 0, length: count(string.utf16))
		var includes: [String] = []
		self.includesRegex.enumerateMatchesInString(string, options: NSMatchingOptions(), range: range) { match, flags, stop in
			let include = nsString.substringWithRange(match.rangeAtIndex(1)) as String
			includes.append(include)
		}
		return includes
	}

	public func parseAttributes(string: String) -> [String:[String]] {
		let nsString = string as NSString
		let range = NSRange(location: 0, length: count(string.utf16))
		var attributes: [String:[String]] = [:]
		self.attributesRegex.enumerateMatchesInString(string, options: NSMatchingOptions(), range: range) { match, flags, stop in
			let key = nsString.substringWithRange(match.rangeAtIndex(1)) as String
			let valuesString = nsString.substringWithRange(match.rangeAtIndex(2)) as String
			var values = self.parseValues(valuesString)
			attributes[key] = values
		}
		return attributes
	}
	
	public func parseValues(string: String) -> [String] {
		let nsString = string as NSString
		let range = NSRange(location: 0, length: count(string.utf16))
		var values: [String] = []
		self.valuesRegex.enumerateComponentsInString(string, options: NSMatchingOptions(), range: range) { range, stop in
			var value = nsString.substringWithRange(range) as String
			let firstCharacter = value[value.startIndex]
			let lastCharacter = value[value.endIndex.predecessor()]
			if ((firstCharacter == "'") && (lastCharacter == "'")) || ((firstCharacter == "\"") && (lastCharacter == "\"")) {
				value = value.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\"'"))
			} else {
				value = value.stringByReplacingOccurrencesOfString("\\ ", withString: " ")
			}			
			values.append(value)
		}
		return values
	}
	
}