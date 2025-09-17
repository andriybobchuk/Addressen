import Foundation
import Combine

enum RepositoryError: Error, LocalizedError {
    case networkError
    case dataCorrupted
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection error"
        case .dataCorrupted:
            return "Data corrupted"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

protocol SalesmanRepositoryProtocol {
    func fetchAllSalesmen() -> AnyPublisher<[Salesman], Error>
}