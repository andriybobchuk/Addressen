import XCTest
import Combine
@testable import addressen

final class FakeSalesmanRepositoryTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testInitWithDefaults() {
        let repository = FakeSalesmanRepository()
        XCTAssertNotNil(repository)
    }
    
    func testInitWithCustomParameters() {
        let repository = FakeSalesmanRepository(delay: 0.5, shouldSimulateError: true)
        XCTAssertNotNil(repository)
    }
    
    func testFetchAllSalesmenSuccess() {
        let repository = FakeSalesmanRepository()
        let expectation = expectation(description: "fetchAllSalesmen success")
        
        repository.fetchAllSalesmen()
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 5)
                    XCTAssertEqual(salesmen[0].name, "Artem Titarenko")
                    XCTAssertEqual(salesmen[0].areas, ["76133"])
                    XCTAssertEqual(salesmen[4].name, "Andrii Bobchuk :)")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchAllSalesmenError() {
        let repository = FakeSalesmanRepository(shouldSimulateError: true)
        let expectation = expectation(description: "fetchAllSalesmen error")
        
        repository.fetchAllSalesmen()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertTrue(error is RepositoryError)
                        if let repoError = error as? RepositoryError {
                            XCTAssertEqual(repoError, RepositoryError.networkError)
                        }
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("Expected error but got success")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenEmptyQuery() {
        let repository = FakeSalesmanRepository()
        let expectation = expectation(description: "searchSalesmen empty query")
        
        repository.searchSalesmen(by: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 5)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenWhitespaceQuery() {
        let repository = FakeSalesmanRepository()
        let expectation = expectation(description: "searchSalesmen whitespace query")
        
        repository.searchSalesmen(by: "   ")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 5)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenExactMatch() {
        let repository = FakeSalesmanRepository()
        let expectation = expectation(description: "searchSalesmen exact match")
        
        repository.searchSalesmen(by: "76133")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 1)
                    XCTAssertEqual(salesmen[0].name, "Artem Titarenko")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenWildcardMatch() {
        let repository = FakeSalesmanRepository()
        let expectation = expectation(description: "searchSalesmen wildcard match")
        
        repository.searchSalesmen(by: "76234")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 1)
                    XCTAssertEqual(salesmen[0].name, "Chris Krapp")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenPartialMatch() {
        let repository = FakeSalesmanRepository()
        let expectation = expectation(description: "searchSalesmen partial match")
        
        repository.searchSalesmen(by: "76")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 3)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenNoMatch() {
        let repository = FakeSalesmanRepository()
        let expectation = expectation(description: "searchSalesmen no match")
        
        repository.searchSalesmen(by: "99999")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 0)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenError() {
        let repository = FakeSalesmanRepository(shouldSimulateError: true)
        let expectation = expectation(description: "searchSalesmen error")
        
        repository.searchSalesmen(by: "76133")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertTrue(error is RepositoryError)
                        if let repoError = error as? RepositoryError {
                            XCTAssertEqual(repoError, RepositoryError.dataCorrupted)
                        }
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("Expected error but got success")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchSalesmenWithDelay() {
        let repository = FakeSalesmanRepository(delay: 0.1)
        let expectation = expectation(description: "searchSalesmen with delay")
        let startTime = Date()
        
        repository.searchSalesmen(by: "76133")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { salesmen in
                    let elapsed = Date().timeIntervalSince(startTime)
                    XCTAssertGreaterThan(elapsed, 0.08)
                    XCTAssertEqual(salesmen.count, 1)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRepositoryErrorMessages() {
        XCTAssertEqual(RepositoryError.networkError.errorDescription, "Network connection error")
        XCTAssertEqual(RepositoryError.dataCorrupted.errorDescription, "Data corrupted")
        XCTAssertEqual(RepositoryError.unknown.errorDescription, "Unknown error occurred")
    }
    
    func testRepositoryErrorEquality() {
        XCTAssertEqual(RepositoryError.networkError, RepositoryError.networkError)
        XCTAssertEqual(RepositoryError.dataCorrupted, RepositoryError.dataCorrupted)
        XCTAssertEqual(RepositoryError.unknown, RepositoryError.unknown)
        XCTAssertNotEqual(RepositoryError.networkError, RepositoryError.dataCorrupted)
    }
}