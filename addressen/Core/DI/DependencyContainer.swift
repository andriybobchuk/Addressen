import Foundation

protocol DependencyContainerProtocol {
    var config: AppConfigurationProtocol { get }
    var salesmanRepository: SalesmanRepositoryProtocol { get }
    var loadSalesmenUseCase: LoadSalesmenUseCaseProtocol { get }
    var searchPostcodeUseCase: SearchPostcodeUseCaseProtocol { get }
    
    @MainActor
    func makeSalesmanListViewModel() -> SalesmanListViewModel
}

final class DependencyContainer: DependencyContainerProtocol {
    static let shared: DependencyContainerProtocol = DependencyContainer()
    
    private init() {}
    
    // If it was production I would probably store in a remote config
    lazy var config: AppConfigurationProtocol = {
        AppConfiguration.shared
    }()
    
    lazy var salesmanRepository: SalesmanRepositoryProtocol = {
        SalesmanRepository()
    }()
    
    lazy var loadSalesmenUseCase: LoadSalesmenUseCaseProtocol = {
        LoadSalesmenUseCase(repository: salesmanRepository)
    }()
    
    lazy var searchPostcodeUseCase: SearchPostcodeUseCaseProtocol = {
        SearchPostcodeUseCase()
    }()
    
    @MainActor
    func makeSalesmanListViewModel() -> SalesmanListViewModel {
        SalesmanListViewModel(
            loadSalesmenUseCase: loadSalesmenUseCase,
            searchPostcodeUseCase: searchPostcodeUseCase,
            config: config
        )
    }
}
