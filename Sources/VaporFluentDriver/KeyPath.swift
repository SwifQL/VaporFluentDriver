//
//  KeyPath.swift
//  SwifQLVapor
//
//  Created by Mihael Isaev on 05/11/2018.
//

import Foundation
import SwifQL
import SwifQLNIO
import FluentKit

extension KeyPath: FluentKitFieldable where Root: FluentKit.Model, Value: QueryableProperty {
    public var schema: String { Root.schema }
	public var key: String {
		guard let first = Root.path(for: self).first else {
			return ""
		}
		return first.description
	}
}

