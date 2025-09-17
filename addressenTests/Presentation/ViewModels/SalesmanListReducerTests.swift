import XCTest
@testable import addressen

final class SalesmanListReducerTests: XCTestCase {
    
    func testReduceLoadSalesmen() {
        let initialState = SalesmanListState()
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .loadSalesmen
        )
        
        XCTAssertEqual(newState.loadingState, .loading)
    }
    
    func testReduceLoadSalesmenFromDifferentState() {
        let initialState = SalesmanListState().copy(
            salesmen: [Salesman(name: "Existing", areas: ["123"])],
            loadingState: .failed("Previous error")
        )
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .loadSalesmen
        )
        
        XCTAssertEqual(newState.loadingState, .loading)
        XCTAssertEqual(newState.salesmen.count, 1) 
    }
    
    func testReduceSearchSalesmen() {
        let initialState = SalesmanListState()
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .searchSalesmen(query: "761")
        )
        
        XCTAssertEqual(newState.searchQuery, "")
        XCTAssertEqual(newState.searchState, SalesmanListState.SearchState.idle)
        XCTAssertEqual(newState, initialState)
    }
    
    func testReduceSearchSalesmenEmpty() {
        let initialState = SalesmanListState()
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .searchSalesmen(query: "")
        )
        
        XCTAssertEqual(newState.searchQuery, "")
        XCTAssertEqual(newState.searchState, SalesmanListState.SearchState.idle)
        XCTAssertEqual(newState.filteredSalesmen.count, 0)
    }
    
    func testReduceClearSearch() {
        let initialState = SalesmanListState().copy(
            filteredSalesmen: [Salesman(name: "Test", areas: ["76133"])],
            searchQuery: "761",
            searchState: SalesmanListState.SearchState.completed(query: "761", results: [])
        )
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .clearSearch
        )
        
        XCTAssertEqual(newState.searchQuery, "")
        XCTAssertEqual(newState.searchState, SalesmanListState.SearchState.idle)
        XCTAssertEqual(newState.filteredSalesmen.count, 0)
    }
    
    func testReduceClearSearchFromDifferentStates() {
        let testSalesmen = [Salesman(name: "Keep", areas: ["123"])]
        let initialState = SalesmanListState().copy(
            salesmen: testSalesmen,
            filteredSalesmen: [Salesman(name: "Test", areas: ["76133"])],
            searchQuery: "761",
            expandedSalesmenIds: Set([UUID()]),
            loadingState: .loaded,
            searchState: SalesmanListState.SearchState.searching(query: "761")
        )
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .clearSearch
        )
        
        XCTAssertEqual(newState.searchQuery, "")
        XCTAssertEqual(newState.searchState, SalesmanListState.SearchState.idle)
        XCTAssertEqual(newState.filteredSalesmen.count, 0)

        XCTAssertEqual(newState.salesmen.count, 1)
        XCTAssertEqual(newState.loadingState, .loaded)
        XCTAssertEqual(newState.expandedSalesmenIds.count, 1)
    }
    
    func testReduceToggleExpansionAdd() {
        let salesmanId = UUID()
        let initialState = SalesmanListState()
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .toggleExpansion(salesmanId: salesmanId)
        )
        
        XCTAssertTrue(newState.expandedSalesmenIds.contains(salesmanId))
    }
    
    func testReduceToggleExpansionRemove() {
        let salesmanId = UUID()
        let initialState = SalesmanListState().copy(
            expandedSalesmenIds: Set([salesmanId])
        )
        
        let newState = SalesmanListReducer.reduce(
            state: initialState,
            intent: .toggleExpansion(salesmanId: salesmanId)
        )
        
        XCTAssertFalse(newState.expandedSalesmenIds.contains(salesmanId))
    }
    
    func testReduceToggleExpansionMultiple() {
        let salesmanId1 = UUID()
        let salesmanId2 = UUID()
        let salesmanId3 = UUID()
        
        let initialState = SalesmanListState().copy(
            expandedSalesmenIds: Set([salesmanId1, salesmanId2])
        )
        
        let newState1 = SalesmanListReducer.reduce(
            state: initialState,
            intent: .toggleExpansion(salesmanId: salesmanId3)
        )
        
        XCTAssertTrue(newState1.expandedSalesmenIds.contains(salesmanId1))
        XCTAssertTrue(newState1.expandedSalesmenIds.contains(salesmanId2))
        XCTAssertTrue(newState1.expandedSalesmenIds.contains(salesmanId3))
        XCTAssertEqual(newState1.expandedSalesmenIds.count, 3)
        
        let newState2 = SalesmanListReducer.reduce(
            state: newState1,
            intent: .toggleExpansion(salesmanId: salesmanId1)
        )
        
        XCTAssertFalse(newState2.expandedSalesmenIds.contains(salesmanId1))
        XCTAssertTrue(newState2.expandedSalesmenIds.contains(salesmanId2))
        XCTAssertTrue(newState2.expandedSalesmenIds.contains(salesmanId3))
        XCTAssertEqual(newState2.expandedSalesmenIds.count, 2)
    }
    
    func testReduceLoadingComplete() {
        let testSalesmen = [
            Salesman(name: "Test1", areas: ["76133"]),
            Salesman(name: "Test2", areas: ["762*"])
        ]
        let initialState = SalesmanListState().copy(loadingState: .loading)
        
        let newState = SalesmanListReducer.reduceLoadingComplete(
            state: initialState,
            salesmen: testSalesmen
        )
        
        XCTAssertEqual(newState.salesmen, testSalesmen)
        XCTAssertEqual(newState.filteredSalesmen.count, 0)
        XCTAssertEqual(newState.loadingState, .loaded)
    }
    
    func testReduceLoadingCompletePreservesOtherState() {
        let testSalesmen = [Salesman(name: "Test", areas: ["76133"])]
        let expandedId = UUID()
        let initialState = SalesmanListState().copy(
            searchQuery: "existing query",
            expandedSalesmenIds: Set([expandedId]),
            loadingState: .loading,
            searchState: .typing(query: "test")
        )
        
        let newState = SalesmanListReducer.reduceLoadingComplete(
            state: initialState,
            salesmen: testSalesmen
        )
        
        XCTAssertEqual(newState.salesmen, testSalesmen)
        XCTAssertEqual(newState.loadingState, .loaded)
        XCTAssertEqual(newState.searchQuery, "existing query")
        XCTAssertTrue(newState.expandedSalesmenIds.contains(expandedId))
        if case .typing(let query) = newState.searchState {
            XCTAssertEqual(query, "test")
        } else {
            XCTFail("Expected typing search state")
        }
    }
    
    func testReduceLoadingFailed() {
        let errorMessage = "Network connection failed"
        let initialState = SalesmanListState().copy(loadingState: .loading)
        
        let newState = SalesmanListReducer.reduceLoadingFailed(
            state: initialState,
            error: errorMessage
        )
        
        if case .failed(let message) = newState.loadingState {
            XCTAssertEqual(message, errorMessage)
        } else {
            XCTFail("Expected failed loading state")
        }
    }
    
    func testReduceLoadingFailedPreservesOtherState() {
        let errorMessage = "Test error"
        let testSalesmen = [Salesman(name: "Existing", areas: ["123"])]
        let expandedId = UUID()
        let initialState = SalesmanListState().copy(
            salesmen: testSalesmen,
            searchQuery: "existing query",
            expandedSalesmenIds: Set([expandedId]),
            loadingState: .loading
        )
        
        let newState = SalesmanListReducer.reduceLoadingFailed(
            state: initialState,
            error: errorMessage
        )
        
        if case .failed(let message) = newState.loadingState {
            XCTAssertEqual(message, errorMessage)
        } else {
            XCTFail("Expected failed loading state")
        }
        
        XCTAssertEqual(newState.salesmen, testSalesmen)
        XCTAssertEqual(newState.searchQuery, "existing query")
        XCTAssertTrue(newState.expandedSalesmenIds.contains(expandedId))
    }
}
