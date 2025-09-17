import XCTest
@testable import addressen

final class LocalizedStringTests: XCTestCase {
    
    func testLocalizedStrings() {
        XCTAssertFalse(LocalizedString.navigationTitle.isEmpty)
        XCTAssertFalse(LocalizedString.searchPlaceholder.isEmpty)
        XCTAssertFalse(LocalizedString.loadingSalesmen.isEmpty)
        XCTAssertFalse(LocalizedString.errorGenericTitle.isEmpty)
        XCTAssertFalse(LocalizedString.errorRetryButton.isEmpty)
        XCTAssertFalse(LocalizedString.emptyNoSalesmenTitle.isEmpty)
        XCTAssertFalse(LocalizedString.emptyNoSalesmenMessage.isEmpty)
        XCTAssertFalse(LocalizedString.emptyNoResultsTitle.isEmpty)
    }
    
    func testEmptyNoResultsMessage() {
        let query = "99999"
        let message = LocalizedString.emptyNoResultsMessage(for: query)
        
        XCTAssertFalse(message.isEmpty)
        XCTAssertTrue(message.contains(query))
    }
    
    func testEmptyNoResultsMessageEmptyQuery() {
        let message = LocalizedString.emptyNoResultsMessage(for: "")
        
        XCTAssertFalse(message.isEmpty)
    }
}