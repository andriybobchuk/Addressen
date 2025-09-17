import Foundation

protocol AppConfigurationProtocol {
    var searchDebounceInterval: TimeInterval { get }
    var animationDuration: TimeInterval { get }
    var minimumSearchLength: Int { get }
    var maxPostcodeLength: Int { get }
}

final class AppConfiguration: AppConfigurationProtocol {
    static let shared = AppConfiguration()
    
    private init() {}
    
    let searchDebounceInterval: TimeInterval = 1.0
    let animationDuration: TimeInterval = 0.3 // just for simplicity, typically I wouldn't put it here
    let minimumSearchLength: Int = 1
    let maxPostcodeLength: Int = 5
}
