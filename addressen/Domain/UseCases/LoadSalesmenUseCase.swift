import Foundation
import Combine

protocol LoadSalesmenUseCaseProtocol {
    func execute() -> AnyPublisher<[Salesman], Error>
}

final class LoadSalesmenUseCase: LoadSalesmenUseCaseProtocol {
    private let repository: SalesmanRepositoryProtocol
    
    init(repository: SalesmanRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Salesman], Error> {
        repository.fetchAllSalesmen()
    }
}