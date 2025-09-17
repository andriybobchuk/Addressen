import Foundation
import Combine

final class SalesmanRepository: SalesmanRepositoryProtocol {
    private let fakeRepository = FakeSalesmanRepository()
    
    func fetchAllSalesmen() -> AnyPublisher<[Salesman], Error> {
        fakeRepository.fetchAllSalesmen()
    }
}