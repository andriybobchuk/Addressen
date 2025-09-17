import Foundation

enum SalesmanListReducer {
    
    static func reduce(
        state: SalesmanListState,
        intent: SalesmanListIntent
    ) -> SalesmanListState {
        switch intent {
        case .loadSalesmen:
            return state.copy(loadingState: .loading)
            
        case .searchSalesmen:
            return state
            
        case .toggleExpansion(let salesmanId):
            return handleToggleExpansion(state: state, salesmanId: salesmanId)
            
        case .clearSearch:
            return state.copy(
                filteredSalesmen: [],
                searchQuery: "",
                searchState: .idle
            )
        }
    }
    
    static func reduceLoadingComplete(
        state: SalesmanListState,
        salesmen: [Salesman]
    ) -> SalesmanListState {
        return state.copy(
            salesmen: salesmen,
            filteredSalesmen: [],
            loadingState: .loaded
        )
    }
    
    static func reduceLoadingFailed(
        state: SalesmanListState,
        error: String
    ) -> SalesmanListState {
        return state.copy(loadingState: .failed(error))
    }
    
    private static func handleToggleExpansion(
        state: SalesmanListState,
        salesmanId: UUID
    ) -> SalesmanListState {
        var newExpandedIds = state.expandedSalesmenIds
        if newExpandedIds.contains(salesmanId) {
            newExpandedIds.remove(salesmanId)
        } else {
            newExpandedIds.insert(salesmanId)
        }
        return state.copy(expandedSalesmenIds: newExpandedIds)
    }
}
