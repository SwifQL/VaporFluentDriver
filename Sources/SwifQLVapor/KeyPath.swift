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

extension KeyPath: FluentKitFieldable where Root: FluentKit.Model, Value: FieldRepresentable {
    public var schema: String { Root.schema }
    public var key: String { Root.key(for: self) }
}
