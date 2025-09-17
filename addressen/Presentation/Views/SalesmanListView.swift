import SwiftUI

struct SalesmanListView: View {
    @StateObject private var viewModel: SalesmanListViewModel
    
    init(dependencyContainer: DependencyContainerProtocol = DependencyContainer.shared) {
        _viewModel = StateObject(wrappedValue: dependencyContainer.makeSalesmanListViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    SearchFieldView(
                        text: Binding(
                            get: { viewModel.state.searchQuery },
                            set: { viewModel.handle(.searchSalesmen(query: $0)) }
                        ),
                        placeholder: LocalizedString.searchPlaceholder,
                        onClear: { viewModel.handle(.clearSearch) }
                    )
                    
                    if viewModel.state.isSearching {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Searching...")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.state.isSearching)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
                
                contentView
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(LocalizedString.navigationTitle)
                        .font(.titleSemibold16)
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color.appAccent, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            viewModel.handle(.loadSalesmen)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.state.isLoading {
            LoadingView()
        } else if viewModel.state.hasError {
            ErrorStateView(
                message: viewModel.state.errorMessage ?? "Unknown error",
                onRetry: { viewModel.handle(.loadSalesmen) }
            )
        } else if viewModel.state.showEmptySearchResult {
            EmptySearchResultView(query: viewModel.state.searchQuery)
        } else if viewModel.state.isEmpty {
            EmptyStateView()
        } else {
            salesmenListView
        }
    }
    
    @ViewBuilder
    private var salesmenListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.state.displayedSalesmen) { salesman in
                    SalesmanRowView(
                        salesman: salesman,
                        isExpanded: viewModel.state.isExpanded(salesman.id),
                        onToggleExpansion: {
                            viewModel.handle(.toggleExpansion(salesmanId: salesman.id))
                        }
                    )
                }
            }
        }
    }
}


struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text(LocalizedString.loadingSalesmen)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text(LocalizedString.errorGenericTitle)
                .font(.system(size: 18, weight: .semibold))
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(LocalizedString.errorRetryButton, action: onRetry)
                .buttonStyle(.bordered)
                .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(LocalizedString.emptyNoSalesmenTitle)
                .font(.system(size: 18, weight: .semibold))
            
            Text(LocalizedString.emptyNoSalesmenMessage)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptySearchResultView: View {
    let query: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(LocalizedString.emptyNoResultsTitle)
                .font(.system(size: 18, weight: .semibold))
            
            Text(LocalizedString.emptyNoResultsMessage(for: query))
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}