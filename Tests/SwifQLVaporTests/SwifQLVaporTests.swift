import XCTest
import SwifQL
@testable import SwifQLVapor

final class SwifQLVaporTests: XCTestCase {
    struct CarBrands: SwifQLTable {
        static var entity: String { return "CarBrands" }
        
        var id: UUID
        var name: String
        var createdAt: Date
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
        checkAllDialects(SwifQL.select(\CarBrands.id), pg: """
            SELECT "CarBrands"."id"
            """, mySQL: """
            SELECT CarBrands.id
            """)
    }
    
    func testSelectCarBrandsSeveralFields() {
        checkAllDialects(SwifQL.select(\CarBrands.id, \CarBrands.name), pg: """
            SELECT "CarBrands"."id", "CarBrands"."name"
            """, mySQL: """
            SELECT CarBrands.id, CarBrands.name
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
        checkAllDialects(SwifQL.select(\CarBrands.id, cb~\.name, \CarBrands.createdAt), pg: """
            SELECT "CarBrands"."id", "cb"."name", "CarBrands"."createdAt"
            """, mySQL: """
            SELECT CarBrands.id, cb.name, CarBrands.createdAt
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
