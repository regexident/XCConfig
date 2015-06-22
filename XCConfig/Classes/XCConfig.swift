//
//  XCConfig.swift
//  XCConfig
//
//  Created by Vincent Esche on 6/17/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Foundation

public struct XCConfig {
	
	public let fileURL: NSURL
	public let attributes: [String:[String]]
	
	public init?(fileURL: NSURL, maxIncludeDepth: Int = 16) {
		let parser = XCConfigParser()
		let string = String(contentsOfURL: fileURL, encoding: NSUTF8StringEncoding, error: nil)
		if string == nil {
			return nil
		}
		var attributes: [String:[String]] = [:]
		if maxIncludeDepth > 0 {
			let includes = parser.parseIncludes(string!)
			for include in includes {
				let includeFileURL = NSURL(string: include, relativeToURL: fileURL)!
				if let xcconfig = XCConfig(fileURL: includeFileURL, maxIncludeDepth: maxIncludeDepth - 1) {
					for (key, values) in xcconfig.attributes {
						attributes[key] = values
					}
				}
			}
		}
		let ownAttributes = parser.parseAttributes(string!)
		for (key, values) in ownAttributes {
			var attributeValues = attributes[key] ?? []
			for value in values {
				if !contains(attributeValues, value) {
					attributeValues.append(value)
				}
			}
			attributes[key] = attributeValues
		}
		self.fileURL = fileURL
		self.attributes = attributes
	}
	
}

extension XCConfig: Printable {
	public var description: String {
		let keys = sorted(self.attributes.keys)
		return reduce(keys, "") { (var string, key) in
			let values = join(" ", self.attributes[key]!.map { contains($0, " ") ? "'\($0)'" : $0 })
			return string + "\(key) = \(values)\n"
		}
	}
}