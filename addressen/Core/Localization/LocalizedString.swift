import Foundation

enum LocalizedString {
    
    // MARK: - Navigation
    static let navigationTitle = NSLocalizedString("navigation.title", comment: "Navigation bar title")
    
    // MARK: - Search
    static let searchPlaceholder = NSLocalizedString("search.placeholder", comment: "Search field placeholder")
    static let searchAccessibilityLabel = NSLocalizedString("search.accessibility.label", comment: "Search field accessibility label")
    static let searchAccessibilityHint = NSLocalizedString("search.accessibility.hint", comment: "Search field accessibility hint")
    static let searchClearAccessibilityLabel = NSLocalizedString("search.clear.accessibility.label", comment: "Clear search button accessibility label")
    static let searchClearAccessibilityHint = NSLocalizedString("search.clear.accessibility.hint", comment: "Clear search button accessibility hint")
    
    // MARK: - Loading States
    static let loadingSalesmen = NSLocalizedString("loading.salesmen", comment: "Loading salesmen text")
    
    // MARK: - Error States
    static let errorGenericTitle = NSLocalizedString("error.generic.title", comment: "Generic error title")
    static let errorRetryButton = NSLocalizedString("error.retry.button", comment: "Retry button text")
    
    // MARK: - Empty States
    static let emptyNoSalesmenTitle = NSLocalizedString("empty.no.salesmen.title", comment: "No salesmen title")
    static let emptyNoSalesmenMessage = NSLocalizedString("empty.no.salesmen.message", comment: "No salesmen message")
    static let emptyNoResultsTitle = NSLocalizedString("empty.no.results.title", comment: "No search results title")
    
    static func emptyNoResultsMessage(for query: String) -> String {
        String(format: NSLocalizedString("empty.no.results.message", comment: "No search results message"), query)
    }
    
    // MARK: - Accessibility
    static let accessibilityExpandHint = NSLocalizedString("accessibility.expand.hint", comment: "Expand accessibility hint")
    static let accessibilityCollapseHint = NSLocalizedString("accessibility.collapse.hint", comment: "Collapse accessibility hint")
}