import XCTest
import Fluent
import Vapor
import SwifQL
@testable import SwifQLVapor

final class SwifQLVaporTests: XCTestCase {
    final class CarBrands: Model, Content, SwifQLTable {
        static let schema = "Car_brands"
        
        static var entity: String { schema }
        
        @ID(key: "id")
        var id: UUID?

        @Field(key: "name")
        var name: String
        
        @Field(key: "createdAt")
        var createdAt: Date?

        init() { }

        init(id: UUID? = nil, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    let cb = CarBrands.as("cb")
    
    func checkAllDialects(_ query: SwifQLable, pg: String? = nil, mySQL: String? = nil) {
        if let pg = pg {
            XCTAssertEqual(query.prepare(.psql).plain, pg)
        }
        if let mySQL = mySQL {
            XCTAssertEqual(query.prepare(.mysql).plain, mySQL)
        }
    }
    
    func testSelectCarBrands() {
        checkAllDialects(SwifQL.select(\CarBrands.id, \CarBrands.$name), pg: """
            SELECT "Car_brands"."id", "Car_brands"."name"
            """, mySQL: """
            SELECT Car_brands.id, Car_brands.name
            """)
    }
    
    func testSelectCarBrandsSeveralFields() {
        checkAllDialects(SwifQL.select(\CarBrands.id, \CarBrands.name, \CarBrands.$createdAt), pg: """
            SELECT "Car_brands"."id", "Car_brands"."name", "Car_brands"."createdAt"
            """, mySQL: """
            SELECT Car_brands.id, Car_brands.name, Car_brands.createdAt
            """)
    }
    
    func testSelectCarBrandsWithAlias() {
        checkAllDialects(SwifQL.select(cb~\.id), pg: """
            SELECT "cb"."id"
            """, mySQL: """
            SELECT cb.id
            """)
    }
    
    func testSelectCarBrandsWithAliasSeveralFields() {
        checkAllDialects(SwifQL.select(cb~\.id, cb~\.name), pg: """
            SELECT "cb"."id", "cb"."name"
            """, mySQL: """
            SELECT cb.id, cb.name
            """)
    }
    
    func testSelectCarBrandsSeveralFieldsMixed() {
        checkAllDialects(SwifQL.select(\CarBrands.$id, cb~\.name, \CarBrands.createdAt), pg: """
            SELECT "Car_brands"."id", "cb"."name", "Car_brands"."createdAt"
            """, mySQL: """
            SELECT Car_brands.id, cb.name, Car_brands.createdAt
            """)
    }

    static var allTests = [
        ("testSelectCarBrands", testSelectCarBrands),
        ("testSelectCarBrandsSeveralFields", testSelectCarBrandsSeveralFields),
        ("testSelectCarBrandsWithAlias", testSelectCarBrandsWithAlias),
        ("testSelectCarBrandsWithAliasSeveralFields", testSelectCarBrandsWithAliasSeveralFields),
        ("testSelectCarBrandsSeveralFieldsMixed", testSelectCarBrandsSeveralFieldsMixed),
    ]
}
