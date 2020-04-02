import XCTest
import Fluent
import Vapor
import SwifQL
@testable import SwifQLVapor

final class SwifQLVaporTests: XCTestCase {
    // MARK: Vapor Fluent model
    
    enum BrandType: String, Codable, SwifQLable {
        case local, foreign
        
        var parts: [SwifQLPart] { [SwifQLPartOperator("'\(rawValue)'")] }
    }
    
    final class CarBrands: Model, Content, SwifQLTable {
        static let schema = "Car_brands"
        
        static var entity: String { schema }
        
        @ID(key: "id")
        var id: UUID?

        @Field(key: "name")
        var name: String
        
        @Enum(key: "type")
        var type: BrandType
        
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
    
    func testEnumInWhereClause() {
        checkAllDialects(SwifQL.where(\CarBrands.$type == BrandType.local), pg: """
            WHERE "Car_brands"."type" = 'local'
            """, mySQL: """
            WHERE Car_brands.type = 'local'
            """)
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
    
    // MARK: Hand made model
    
    struct CarModels: Codable, Reflectable, Tableable {
        static var entity: String { return "CarModels" }
        
        var id: UUID
        var brandId: UUID
        var name: String
        var createdAt: Date
    }
    
    let cm = CarModels.as("cm")
    
    func testSelectCarModels() {
        checkAllDialects(SwifQL.select(\CarModels.id), pg: """
            SELECT "CarModels"."id"
            """, mySQL: """
            SELECT CarModels.id
            """)
    }
    
    func testSelectCarModelsSeveralFields() {
        checkAllDialects(SwifQL.select(\CarModels.id, \CarModels.name), pg: """
            SELECT "CarModels"."id", "CarModels"."name"
            """, mySQL: """
            SELECT CarModels.id, CarModels.name
            """)
    }
    
    func testSelectCarModelsWithAlias() {
        checkAllDialects(SwifQL.select(cm~\.id), pg: """
            SELECT "cm"."id"
            """, mySQL: """
            SELECT cm.id
            """)
    }
    
    func testSelectCarModelsWithAliasSeveralFields() {
        checkAllDialects(SwifQL.select(cm~\.id, cm~\.name), pg: """
            SELECT "cm"."id", "cm"."name"
            """, mySQL: """
            SELECT cm.id, cm.name
            """)
    }
    
    func testSelectCarModelsSeveralFieldsMixed() {
        checkAllDialects(SwifQL.select(\CarModels.id, cm~\.name, \CarModels.createdAt), pg: """
            SELECT "CarModels"."id", "cm"."name", "CarModels"."createdAt"
            """, mySQL: """
            SELECT CarModels.id, cm.name, CarModels.createdAt
            """)
    }

    static var allTests = [
        ("testSelectCarBrands", testSelectCarBrands),
        ("testSelectCarBrandsSeveralFields", testSelectCarBrandsSeveralFields),
        ("testSelectCarBrandsWithAlias", testSelectCarBrandsWithAlias),
        ("testSelectCarBrandsWithAliasSeveralFields", testSelectCarBrandsWithAliasSeveralFields),
        ("testSelectCarBrandsSeveralFieldsMixed", testSelectCarBrandsSeveralFieldsMixed),
        
        ("testSelectCarModels", testSelectCarModels),
        ("testSelectCarModelsSeveralFields", testSelectCarModelsSeveralFields),
        ("testSelectCarModelsWithAlias", testSelectCarModelsWithAlias),
        ("testSelectCarModelsWithAliasSeveralFields", testSelectCarModelsWithAliasSeveralFields),
        ("testSelectCarModelsSeveralFieldsMixed", testSelectCarModelsSeveralFieldsMixed),
    ]
}
