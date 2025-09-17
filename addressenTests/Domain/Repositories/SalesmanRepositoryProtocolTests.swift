import XCTest
@testable import addressen

final class SalesmanRepositoryProtocolTests: XCTestCase {
    
    func testRepositoryErrorDescriptions() {
        XCTAssertEqual(RepositoryError.networkError.errorDescription, "Network connection error")
        XCTAssertEqual(RepositoryError.dataCorrupted.errorDescription, "Data corrupted")
        XCTAssertEqual(RepositoryError.unknown.errorDescription, "Unknown error occurred")
    }
    
    func testRepositoryErrorEquality() {
        XCTAssertEqual(RepositoryError.networkError, RepositoryError.networkError)
        XCTAssertEqual(RepositoryError.dataCorrupted, RepositoryError.dataCorrupted)
        XCTAssertEqual(RepositoryError.unknown, RepositoryError.unknown)
        
        XCTAssertNotEqual(RepositoryError.networkError, RepositoryError.dataCorrupted)
        XCTAssertNotEqual(RepositoryError.networkError, RepositoryError.unknown)
        XCTAssertNotEqual(RepositoryError.dataCorrupted, RepositoryError.unknown)
    }
}