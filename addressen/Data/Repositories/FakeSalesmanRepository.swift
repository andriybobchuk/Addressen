import Foundation
import Combine

final class FakeSalesmanRepository: SalesmanRepositoryProtocol {
    private let salesmen: [Salesman] = [
        Salesman(name: "Artem Titarenko", areas: ["76133"]),
        Salesman(name: "Bernd Schmitt", areas: ["7619*"]),
        Salesman(name: "Chris Krapp", areas: ["762*"]),
        Salesman(name: "Alex Uber", areas: ["86*"]),
        Salesman(name: "Andrii Bobchuk :)", areas: ["860*", "44100", "33*", "8140*", "00851", "00865"]),
    ]
    
    private let delay: TimeInterval
    private let shouldSimulateError: Bool
    
    init(delay: TimeInterval = 0.0, shouldSimulateError: Bool = false) {
        self.delay = delay
        self.shouldSimulateError = shouldSimulateError
    }
    
    func fetchAllSalesmen() -> AnyPublisher<[Salesman], Error> {
        if shouldSimulateError {
            return Fail(error: RepositoryError.networkError)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        return Just(salesmen)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchSalesmen(by query: String) -> AnyPublisher<[Salesman], Error> {
        if shouldSimulateError {
            return Fail(error: RepositoryError.dataCorrupted)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if normalizedQuery.isEmpty {
            return Just(salesmen)
                .setFailureType(to: Error.self)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        let searchUseCase = SearchPostcodeUseCase()
        let filtered = searchUseCase.execute(salesmen: salesmen, query: normalizedQuery)
        
        return Just(filtered)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
