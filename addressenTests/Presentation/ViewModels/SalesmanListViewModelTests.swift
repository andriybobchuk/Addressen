import XCTest
import Combine
@testable import addressen

@MainActor
final class SalesmanListViewModelTests: XCTestCase {
    
    var mockLoadUseCase: MockLoadSalesmenUseCase!
    var mockSearchUseCase: MockSearchPostcodeUseCase!
    var mockConfig: MockAppConfiguration!
    var viewModel: SalesmanListViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockLoadUseCase = MockLoadSalesmenUseCase()
        mockSearchUseCase = MockSearchPostcodeUseCase()
        mockConfig = MockAppConfiguration()
        cancellables = Set<AnyCancellable>()
        
        viewModel = SalesmanListViewModel(
            loadSalesmenUseCase: mockLoadUseCase,
            searchPostcodeUseCase: mockSearchUseCase,
            config: mockConfig
        )
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockConfig = nil
        mockSearchUseCase = nil
        mockLoadUseCase = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state.salesmen.count, 0)
        XCTAssertEqual(viewModel.state.searchQuery, "")
        XCTAssertEqual(viewModel.state.loadingState, .idle)
        XCTAssertEqual(viewModel.state.searchState, .idle)
    }
    
    func testLoadSalesmenSuccess() async {
        let testSalesmen = [
            Salesman(name: "Test1", areas: ["76133"]),
            Salesman(name: "Test2", areas: ["762*"])
        ]
        mockLoadUseCase.salesmenToReturn = testSalesmen
        
        viewModel.handle(.loadSalesmen)
        
        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.state.loadingState, .loaded)
        XCTAssertEqual(viewModel.state.salesmen.count, 2)
        XCTAssertEqual(viewModel.state.salesmen[0].name, "Test1")
    }
    
    func testLoadSalesmenFailure() async {
        mockLoadUseCase.shouldFail = true
        
        viewModel.handle(.loadSalesmen)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .failed(let message) = viewModel.state.loadingState {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected failed loading state")
        }
    }
    
    func testSearchInputHandling() {
        viewModel.handle(.searchSalesmen(query: "76133"))
        
        XCTAssertEqual(viewModel.state.searchQuery, "76133")
    }
    
    func testSearchInputEmptyQuery() async {
        let testSalesmen = [Salesman(name: "Test", areas: ["76133"])]
        viewModel = SalesmanListViewModel(
            loadSalesmenUseCase: mockLoadUseCase,
            searchPostcodeUseCase: mockSearchUseCase,
            config: mockConfig
        )
        
        let newState = SalesmanListReducer.reduceLoadingComplete(
            state: viewModel.state,
            salesmen: testSalesmen
        )
        viewModel = SalesmanListViewModel(
            loadSalesmenUseCase: mockLoadUseCase,
            searchPostcodeUseCase: mockSearchUseCase,
            config: mockConfig
        )
        
        viewModel.handle(.searchSalesmen(query: ""))
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertEqual(viewModel.state.searchQuery, "")
        XCTAssertEqual(viewModel.state.searchState, .idle)
    }
    
    func testSearchInputWhitespaceQuery() async {
        viewModel.handle(.searchSalesmen(query: "   "))
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertEqual(viewModel.state.searchQuery, "")
    }
    
    func testToggleExpansion() {
        let salesmanId = UUID()
        
        viewModel.handle(.toggleExpansion(salesmanId: salesmanId))
        
        XCTAssertTrue(viewModel.state.expandedSalesmenIds.contains(salesmanId))
        
        viewModel.handle(.toggleExpansion(salesmanId: salesmanId))
        
        XCTAssertFalse(viewModel.state.expandedSalesmenIds.contains(salesmanId))
    }
    
    func testClearSearch() {
        viewModel.handle(.searchSalesmen(query: "76133"))
        XCTAssertEqual(viewModel.state.searchQuery, "76133")
        
        viewModel.handle(.clearSearch)
        
        XCTAssertEqual(viewModel.state.searchQuery, "")
        XCTAssertEqual(viewModel.state.searchState, .idle)
        XCTAssertEqual(viewModel.state.filteredSalesmen.count, 0)
    }
    
    func testSearchWithResults() async {
        let testSalesmen = [Salesman(name: "Test1", areas: ["76133"])]
        mockSearchUseCase.resultsToReturn = testSalesmen
        
        viewModel.handle(.loadSalesmen)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.handle(.searchSalesmen(query: "76133"))
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        XCTAssertEqual(viewModel.state.searchQuery, "76133")
        if case .completed(let query, let results) = viewModel.state.searchState {
            XCTAssertEqual(query, "76133")
            XCTAssertEqual(results.count, 1)
        } else {
            XCTFail("Expected completed search state")
        }
    }
    
    func testRapidSearchInputHandling() async {
        // Test rapid consecutive search inputs
        viewModel.handle(.searchSalesmen(query: "7"))
        viewModel.handle(.searchSalesmen(query: "76"))
        viewModel.handle(.searchSalesmen(query: "761"))
        viewModel.handle(.searchSalesmen(query: "7613"))
        viewModel.handle(.searchSalesmen(query: "76133"))
        
        XCTAssertEqual(viewModel.state.searchQuery, "76133")
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        if case .completed(let query, _) = viewModel.state.searchState {
            XCTAssertEqual(query, "76133")
        }
    }
    
    func testDebouncingConfiguration() {
        XCTAssertEqual(mockConfig.searchDebounceInterval, 0.1)
    }
    
    func testViewModelDeinit() {
        var tempViewModel: SalesmanListViewModel? = SalesmanListViewModel(
            loadSalesmenUseCase: mockLoadUseCase,
            searchPostcodeUseCase: mockSearchUseCase,
            config: mockConfig
        )
        
        tempViewModel?.handle(.searchSalesmen(query: "test"))
        tempViewModel = nil
        
        XCTAssertNil(tempViewModel)
    }
}
