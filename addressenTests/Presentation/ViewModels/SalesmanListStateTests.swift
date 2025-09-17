import XCTest
@testable import addressen

final class SalesmanListStateTests: XCTestCase {
    
    func testInitialState() {
        let state = SalesmanListState()
        
        XCTAssertEqual(state.salesmen.count, 0)
        XCTAssertEqual(state.filteredSalesmen.count, 0)
        XCTAssertEqual(state.searchQuery, "")
        XCTAssertEqual(state.loadingState, .idle)
        XCTAssertEqual(state.searchState, SalesmanListState.SearchState.idle)
        XCTAssertEqual(state.expandedSalesmenIds.count, 0)
    }
    
    func testCopyWithSalesmen() {
        let initialState = SalesmanListState()
        let salesmen = [Salesman(name: "Test", areas: ["76133"])]
        
        let newState = initialState.copy(salesmen: salesmen)
        
        XCTAssertEqual(newState.salesmen.count, 1)
        XCTAssertEqual(newState.salesmen[0].name, "Test")

        XCTAssertEqual(initialState.salesmen.count, 0)
    }
    
    func testCopyWithSearchQuery() {
        let initialState = SalesmanListState()
        
        let newState = initialState.copy(searchQuery: "test")
        
        XCTAssertEqual(newState.searchQuery, "test")
        XCTAssertEqual(initialState.searchQuery, "")
    }
    
    func testCopyWithLoadingState() {
        let initialState = SalesmanListState()
        
        let newState = initialState.copy(loadingState: .loading)
        
        XCTAssertEqual(newState.loadingState, .loading)
        XCTAssertEqual(initialState.loadingState, .idle)
    }
    
    func testDisplayedSalesmenWhenIdle() {
        let salesmen = [Salesman(name: "Test", areas: ["76133"])]
        let state = SalesmanListState().copy(
            salesmen: salesmen,
            searchState: SalesmanListState.SearchState.idle
        )
        
        XCTAssertEqual(state.displayedSalesmen, salesmen)
    }
    
    func testDisplayedSalesmenWhenTyping() {
        let salesmen = [Salesman(name: "Test", areas: ["76133"])]
        let state = SalesmanListState().copy(
            salesmen: salesmen,
            searchState: SalesmanListState.SearchState.typing(query: "76")
        )
        
        XCTAssertEqual(state.displayedSalesmen, salesmen)
    }
    
    func testDisplayedSalesmenWhenSearching() {
        let salesmen = [Salesman(name: "Test", areas: ["76133"])]
        let state = SalesmanListState().copy(
            salesmen: salesmen,
            searchState: SalesmanListState.SearchState.searching(query: "76")
        )
        
        XCTAssertEqual(state.displayedSalesmen, salesmen)
    }
    
    func testDisplayedSalesmenWhenCompleted() {
        let allSalesmen = [
            Salesman(name: "Test1", areas: ["76133"]),
            Salesman(name: "Test2", areas: ["86*"])
        ]
        let filteredSalesmen = [allSalesmen[0]]
        
        let state = SalesmanListState().copy(
            salesmen: allSalesmen,
            searchState: SalesmanListState.SearchState.completed(query: "761", results: filteredSalesmen)
        )
        
        XCTAssertEqual(state.displayedSalesmen, filteredSalesmen)
    }
    
    func testShowEmptySearchResult() {
        let state = SalesmanListState().copy(
            loadingState: .loaded,
            searchState: SalesmanListState.SearchState.completed(query: "99999", results: [])
        )
        
        XCTAssertTrue(state.showEmptySearchResult)
    }
    
    func testShowEmptySearchResultFalseWhenSearching() {
        let state = SalesmanListState().copy(
            loadingState: .loaded,
            searchState: SalesmanListState.SearchState.searching(query: "99999")
        )
        
        XCTAssertFalse(state.showEmptySearchResult)
    }
    
    func testShowEmptySearchResultFalseWhenHasResults() {
        let results = [Salesman(name: "Test", areas: ["76133"])]
        let state = SalesmanListState().copy(
            loadingState: .loaded,
            searchState: SalesmanListState.SearchState.completed(query: "761", results: results)
        )
        
        XCTAssertFalse(state.showEmptySearchResult)
    }
}
