//
//  SwifQLable+Execute.swift
//  SwifQLVapor
//
//  Created by Mihael Isaev on 12/12/2018.
//

import SwifQL
import SwifQLNIO
import Vapor
import FluentKit
import PostgresKit

extension SwifQLable {
    @discardableResult
    public func execute(on database: PostgresDatabase) -> EventLoopFuture<[PostgresRow]> {
        let prepared = prepare(.psql).splitted
        return database.eventLoop.future().flatMapThrowing {
            try prepared.values.map { try PostgresDataEncoder().encode($0) }
        }.flatMap { values in
            database.query(prepared.query, values)
        }.map {
            $0.rows
        }
    }
}

public protocol SwifQLTable: Model, Tableable, Reflectable {
    static var entity: String { get }
}

extension SwifQLTable {
    public static var entity: String { schema }
}
