import XCTest
@testable import addressen

final class SimpleTests: XCTestCase {
    
    // MARK: - Basic Model Tests
    
    func testSalesman() {
        let salesman = Salesman(name: "Test", areas: ["76133"])
        XCTAssertEqual(salesman.name, "Test")
        XCTAssertEqual(salesman.areas.count, 1)
        XCTAssertEqual(salesman.areas[0], "76133")
    }
    
    func testSalesmanFormattedAreas() {
        let salesman = Salesman(name: "Test", areas: ["76133", "762*"])
        XCTAssertEqual(salesman.formattedAreas, "76133, 762*")
    }
    
    // MARK: - Configuration Tests
    
    func testAppConfiguration() {
        let config = AppConfiguration.shared
        XCTAssertEqual(config.searchDebounceInterval, 1.0)
        XCTAssertEqual(config.animationDuration, 0.3)
        XCTAssertEqual(config.minimumSearchLength, 1)
        XCTAssertEqual(config.maxPostcodeLength, 5)
    }
    
    func testMockConfiguration() {
        let config = MockAppConfiguration()
        XCTAssertEqual(config.searchDebounceInterval, 0.1)
        XCTAssertEqual(config.animationDuration, 0.1)
        XCTAssertEqual(config.minimumSearchLength, 1)
        XCTAssertEqual(config.maxPostcodeLength, 5)
    }
    
    // MARK: - Search Use Case Tests
    
    func testSearchUseCase() {
        let useCase = SearchPostcodeUseCase()
        let salesmen = [
            Salesman(name: "Test1", areas: ["76133"]),
            Salesman(name: "Test2", areas: ["86*"])
        ]
        
        // Test exact match
        let result1 = useCase.execute(salesmen: salesmen, query: "76133")
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0].name, "Test1")
        
        // Test empty query returns all
        let result2 = useCase.execute(salesmen: salesmen, query: "")
        XCTAssertEqual(result2.count, 2)
        
        // Test no match
        let result3 = useCase.execute(salesmen: salesmen, query: "99999")
        XCTAssertEqual(result3.count, 0)
    }
    
    // MARK: - State Tests
    
    func testSalesmanListStateInit() {
        let state = SalesmanListState()
        XCTAssertEqual(state.salesmen.count, 0)
        XCTAssertEqual(state.searchQuery, "")
        XCTAssertEqual(state.loadingState, LoadingState.idle)
    }
    
    func testSalesmanListStateCopy() {
        let initialState = SalesmanListState()
        let salesmen = [Salesman(name: "Test", areas: ["76133"])]
        
        let newState = initialState.copy(salesmen: salesmen)
        XCTAssertEqual(newState.salesmen.count, 1)
        XCTAssertEqual(newState.salesmen[0].name, "Test")
        
        // Original unchanged
        XCTAssertEqual(initialState.salesmen.count, 0)
    }
    
    // MARK: - Repository Error Tests
    
    func testRepositoryErrors() {
        XCTAssertEqual(RepositoryError.networkError.errorDescription, "Network connection error")
        XCTAssertEqual(RepositoryError.dataCorrupted.errorDescription, "Data corrupted")
        XCTAssertEqual(RepositoryError.unknown.errorDescription, "Unknown error occurred")
    }
    
    // MARK: - Localization Tests
    
    func testLocalizedStrings() {
        XCTAssertFalse(LocalizedString.navigationTitle.isEmpty)
        XCTAssertFalse(LocalizedString.searchPlaceholder.isEmpty)
        XCTAssertFalse(LocalizedString.loadingSalesmen.isEmpty)
    }
    
    func testEmptyResultsMessage() {
        let message = LocalizedString.emptyNoResultsMessage(for: "99999")
        XCTAssertFalse(message.isEmpty)
        XCTAssertTrue(message.contains("99999"))
    }
}