import Foundation

enum SalesmanListIntent {
    case loadSalesmen
    case searchSalesmen(query: String)
    case toggleExpansion(salesmanId: UUID)
    case clearSearch
}