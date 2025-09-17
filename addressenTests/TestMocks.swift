import Foundation
import Combine
@testable import addressen

class MockLoadSalesmenUseCase: LoadSalesmenUseCaseProtocol {
    var salesmenToReturn: [Salesman] = []
    var shouldFail = false
    var executeCalled = false
    
    func execute() -> AnyPublisher<[Salesman], Error> {
        executeCalled = true
        if shouldFail {
            return Fail(error: RepositoryError.networkError).eraseToAnyPublisher()
        }
        return Just(salesmenToReturn).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

class MockAppConfiguration: AppConfigurationProtocol {
    var searchDebounceInterval: TimeInterval = 0.1
    var animationDuration: TimeInterval = 0.1
    var minimumSearchLength: Int = 1
    var maxPostcodeLength: Int = 5
}

class MockSearchPostcodeUseCase: SearchPostcodeUseCaseProtocol {
    var resultsToReturn: [Salesman] = []
    var executeCalled = false
    var lastSalesmen: [Salesman] = []
    var lastQuery: String = ""
    
    func execute(salesmen: [Salesman], query: String) -> [Salesman] {
        executeCalled = true
        lastSalesmen = salesmen
        lastQuery = query
        return resultsToReturn
    }
}

class MockSearchPostcodeUseCaseWithTracking: MockSearchPostcodeUseCase {
    var onExecute: (() -> Void)?
    
    override func execute(salesmen: [Salesman], query: String) -> [Salesman] {
        onExecute?()
        return super.execute(salesmen: salesmen, query: query)
    }
}

class MockSalesmanRepository: SalesmanRepositoryProtocol {
    var salesmenToReturn: [Salesman] = []
    var shouldFail = false
    
    func fetchAllSalesmen() -> AnyPublisher<[Salesman], Error> {
        if shouldFail {
            return Fail(error: RepositoryError.networkError).eraseToAnyPublisher()
        }
        return Just(salesmenToReturn).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}