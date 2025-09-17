import XCTest
@testable import addressen

final class SearchPostcodeUseCaseTests: XCTestCase {
    
    var useCase: SearchPostcodeUseCase!
    var testSalesmen: [Salesman]!
    
    override func setUp() {
        super.setUp()
        useCase = SearchPostcodeUseCase()
        testSalesmen = [
            Salesman(name: "Test1", areas: ["76133"]),
            Salesman(name: "Test2", areas: ["762*"]),
            Salesman(name: "Test3", areas: ["86*"]),
            Salesman(name: "Test4", areas: ["76200", "86100"])
        ]
    }
    
    override func tearDown() {
        useCase = nil
        testSalesmen = nil
        super.tearDown()
    }
    
    func testExactMatch() {
        let result = useCase.execute(salesmen: testSalesmen, query: "76133")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "Test1")
    }
    
    func testWildcardMatch() {
        let result = useCase.execute(salesmen: testSalesmen, query: "76234")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "Test2")
    }
    
    func testPartialMatch() {
        let result = useCase.execute(salesmen: testSalesmen, query: "76")
        
        XCTAssertEqual(result.count, 3)
    }
    
    func testEmptyQuery() {
        let result = useCase.execute(salesmen: testSalesmen, query: "")
        
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result, testSalesmen)
    }
    
    func testWhitespaceQuery() {
        let result = useCase.execute(salesmen: testSalesmen, query: "   ")
        
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result, testSalesmen)
    }
    
    func testNoMatch() {
        let result = useCase.execute(salesmen: testSalesmen, query: "99999")
        
        XCTAssertEqual(result.count, 0)
    }
    
    func testLengthLimit() {
        let result = useCase.execute(salesmen: testSalesmen, query: "761334567890")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "Test1")
    }
}
