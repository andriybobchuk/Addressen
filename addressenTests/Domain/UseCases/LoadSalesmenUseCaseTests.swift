import XCTest
import Combine
@testable import addressen

final class LoadSalesmenUseCaseTests: XCTestCase {
    
    var useCase: LoadSalesmenUseCase!
    var mockRepository: MockSalesmanRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockSalesmanRepository()
        useCase = LoadSalesmenUseCase(repository: mockRepository)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() {
        let testSalesmen = [Salesman(name: "Test", areas: ["76133"])]
        mockRepository.salesmenToReturn = testSalesmen
        
        let expectation = expectation(description: "Load salesmen success")
        
        useCase.execute()
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not fail")
                    }
                },
                receiveValue: { salesmen in
                    XCTAssertEqual(salesmen.count, 1)
                    XCTAssertEqual(salesmen[0].name, "Test")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecuteFailure() {
        mockRepository.shouldFail = true
        
        let expectation = expectation(description: "Load salesmen failure")
        
        useCase.execute()
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("Should not receive value")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}