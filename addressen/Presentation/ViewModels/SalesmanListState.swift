import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

struct SalesmanListState: Equatable {
    let salesmen: [Salesman]
    let filteredSalesmen: [Salesman]
    let searchQuery: String
    let expandedSalesmenIds: Set<UUID>
    let loadingState: LoadingState
    let searchState: SearchState
    
    enum SearchState: Equatable {
        case idle
        case typing(query: String)
        case searching(query: String)
        case completed(query: String, results: [Salesman])
    }
    
    init(
        salesmen: [Salesman] = [],
        filteredSalesmen: [Salesman] = [],
        searchQuery: String = "",
        expandedSalesmenIds: Set<UUID> = [],
        loadingState: LoadingState = .idle,
        searchState: SearchState = .idle
    ) {
        self.salesmen = salesmen
        self.filteredSalesmen = filteredSalesmen
        self.searchQuery = searchQuery
        self.expandedSalesmenIds = expandedSalesmenIds
        self.loadingState = loadingState
        self.searchState = searchState
    }
    
    var displayedSalesmen: [Salesman] {
        switch searchState {
        case .idle:
            return salesmen
        case .typing:
            return salesmen
        case .searching:
            return salesmen
        case .completed(_, let results):
            return results
        }
    }
    
    var isEmpty: Bool {
        loadingState == .loaded && displayedSalesmen.isEmpty
    }
    
    var showEmptySearchResult: Bool {
        if case .completed(let query, let results) = searchState {
            return !query.isEmpty && results.isEmpty && loadingState == .loaded
        }
        return false
    }
    
    var isSearching: Bool {
        if case .searching = searchState {
            return true
        }
        return false
    }
    
    var isTyping: Bool {
        if case .typing = searchState {
            return true
        }
        return false
    }
    
    var isLoading: Bool {
        loadingState == .loading
    }
    
    var hasError: Bool {
        if case .failed = loadingState {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .failed(let message) = loadingState {
            return message
        }
        return nil
    }
    
    var showContent: Bool {
        loadingState == .loaded && !displayedSalesmen.isEmpty
    }
    
    func isExpanded(_ salesmanId: UUID) -> Bool {
        expandedSalesmenIds.contains(salesmanId)
    }
    
    func copy(
        salesmen: [Salesman]? = nil,
        filteredSalesmen: [Salesman]? = nil,
        searchQuery: String? = nil,
        expandedSalesmenIds: Set<UUID>? = nil,
        loadingState: LoadingState? = nil,
        searchState: SearchState? = nil
    ) -> SalesmanListState {
        SalesmanListState(
            salesmen: salesmen ?? self.salesmen,
            filteredSalesmen: filteredSalesmen ?? self.filteredSalesmen,
            searchQuery: searchQuery ?? self.searchQuery,
            expandedSalesmenIds: expandedSalesmenIds ?? self.expandedSalesmenIds,
            loadingState: loadingState ?? self.loadingState,
            searchState: searchState ?? self.searchState
        )
    }
}
