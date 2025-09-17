import XCTest
@testable import addressen

final class SalesmanTests: XCTestCase {
    
    func testInit() {
        let salesman = Salesman(name: "Test User", areas: ["76133", "762*"])
        
        XCTAssertEqual(salesman.name, "Test User")
        XCTAssertEqual(salesman.areas.count, 2)
        XCTAssertEqual(salesman.areas[0], "76133")
        XCTAssertEqual(salesman.areas[1], "762*")
    }
    
    func testFormattedAreas() {
        let salesman = Salesman(name: "Test", areas: ["76133", "762*", "86*"])
        XCTAssertEqual(salesman.formattedAreas, "76133, 762*, 86*")
    }
    
    func testFormattedAreasEmpty() {
        let salesman = Salesman(name: "Test", areas: [])
        XCTAssertEqual(salesman.formattedAreas, "")
    }
    
    func testFormattedAreasSingle() {
        let salesman = Salesman(name: "Test", areas: ["76133"])
        XCTAssertEqual(salesman.formattedAreas, "76133")
    }
}