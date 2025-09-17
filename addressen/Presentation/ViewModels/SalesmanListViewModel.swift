import Foundation
import Combine
import SwiftUI

@MainActor
final class SalesmanListViewModel: ObservableObject {
    @Published private(set) var state = SalesmanListState()
    
    private let loadSalesmenUseCase: LoadSalesmenUseCaseProtocol
    private let searchPostcodeUseCase: SearchPostcodeUseCaseProtocol
    private let config: AppConfigurationProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private let searchInputSubject = CurrentValueSubject<String, Never>("")
    private var currentSearchCancellable: AnyCancellable?
    
    init(
        loadSalesmenUseCase: LoadSalesmenUseCaseProtocol,
        searchPostcodeUseCase: SearchPostcodeUseCaseProtocol = SearchPostcodeUseCase(),
        config: AppConfigurationProtocol
    ) {
        self.loadSalesmenUseCase = loadSalesmenUseCase
        self.searchPostcodeUseCase = searchPostcodeUseCase
        self.config = config
        setupSearchDebouncing()
    }
    
    private func setupSearchDebouncing() {
        searchInputSubject
            .debounce(for: .seconds(config.searchDebounceInterval), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.executeSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        currentSearchCancellable?.cancel()
        cancellables.removeAll()
    }
    
    func handle(_ intent: SalesmanListIntent) {
        let newState = SalesmanListReducer.reduce(state: state, intent: intent)
        state = newState
        
        switch intent {
        case .loadSalesmen:
            loadSalesmen()
            
        case .searchSalesmen(let query):
            handleSearchInput(query: query)
            
        case .toggleExpansion, .clearSearch:
            break
        }
    }
    
    private func loadSalesmen() {
        loadSalesmenUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        if case .failure(let error) = completion {
                            self.state = SalesmanListReducer.reduceLoadingFailed(
                                state: self.state,
                                error: error.localizedDescription
                            )
                        }
                    }
                },
                receiveValue: { [weak self] salesmen in
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        self.state = SalesmanListReducer.reduceLoadingComplete(
                            state: self.state,
                            salesmen: salesmen
                        )
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func handleSearchInput(query: String) {
        currentSearchCancellable?.cancel()
        
        state = state.copy(searchQuery: query)
        
        searchInputSubject.send(query)
    }
    
    private func executeSearch(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        currentSearchCancellable?.cancel()
        
        if trimmedQuery.isEmpty {
            state = state.copy(
                filteredSalesmen: [],
                searchQuery: "",
                searchState: .idle
            )
            return
        }
        
        state = state.copy(searchState: .searching(query: trimmedQuery))
        
        currentSearchCancellable = Just(())
            .delay(for: .milliseconds(10), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let searchResults = self.searchPostcodeUseCase.execute(
                    salesmen: self.state.salesmen, 
                    query: trimmedQuery
                )
                
                self.state = self.state.copy(
                    filteredSalesmen: searchResults,
                    searchState: .completed(query: trimmedQuery, results: searchResults)
                )
            }
    }
}
