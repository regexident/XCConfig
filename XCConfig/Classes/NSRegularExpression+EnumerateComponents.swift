//
//  NSRegularExpression+EnumerateComponents.swift
//  XCConfig
//
//  Created by Vincent Esche on 6/9/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Foundation

extension NSRegularExpression {
	
	func enumerateComponentsInString(string: String, options: NSMatchingOptions, range: NSRange, usingBlock block: (NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
		var wasStopped: ObjCBool = false
		var location = 0
		let nsString = string as NSString
		self.enumerateMatchesInString(string, options: options, range: range) { match, flags, stop in
			let matchRange = match.range
			let componentRange = NSRange(location: location, length: matchRange.location - location)
			block(componentRange, stop)
			wasStopped = stop.memory
			location = matchRange.location + matchRange.length
		}
		if !wasStopped {
			var stopPointer = UnsafeMutablePointer<ObjCBool>.alloc(1)
			block(NSRange(location: location, length: (range.location + range.length) - location), stopPointer)
			stopPointer.dealloc(1)
		}
	}
	
}