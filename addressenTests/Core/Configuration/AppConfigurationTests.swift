import XCTest
@testable import addressen

final class AppConfigurationTests: XCTestCase {
    
    func testAppConfigurationValues() {
        let config = AppConfiguration.shared
        
        XCTAssertEqual(config.searchDebounceInterval, 1.0)
        XCTAssertEqual(config.animationDuration, 0.3)
        XCTAssertEqual(config.minimumSearchLength, 1)
        XCTAssertEqual(config.maxPostcodeLength, 5)
    }
    
    func testAppConfigurationSingleton() {
        let config1 = AppConfiguration.shared
        let config2 = AppConfiguration.shared
        
        XCTAssertTrue(config1 === config2)
    }
    
    func testMockAppConfiguration() {
        let mockConfig = MockAppConfiguration()
        
        XCTAssertEqual(mockConfig.searchDebounceInterval, 0.1)
        XCTAssertEqual(mockConfig.animationDuration, 0.1)
        XCTAssertEqual(mockConfig.minimumSearchLength, 1)
        XCTAssertEqual(mockConfig.maxPostcodeLength, 5)
    }
}