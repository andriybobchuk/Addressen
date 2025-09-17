/**
 * Implements wildcard postcode matching with built-in input validation. I could make validation a separate use case but didn't for simplicity
 */
import Foundation

protocol SearchPostcodeUseCaseProtocol {
    func execute(salesmen: [Salesman], query: String) -> [Salesman]
}

final class SearchPostcodeUseCase: SearchPostcodeUseCaseProtocol {
    
    func execute(salesmen: [Salesman], query: String) -> [Salesman] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            return salesmen
        }
        
        let limitedQuery = String(trimmedQuery.prefix(5))
        
        return salesmen.filter { salesman in
            salesman.areas.contains { area in
                matchesPostcode(area: area, query: limitedQuery)
            }
        }
    }
    
    private func matchesPostcode(area: String, query: String) -> Bool {
        let normalizedArea = area.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if normalizedArea.hasSuffix("*") {
            let areaPrefix = String(normalizedArea.dropLast())
            
            if normalizedQuery.hasSuffix("*") {
                let queryPrefix = String(normalizedQuery.dropLast())
                return areaPrefix.hasPrefix(queryPrefix) || queryPrefix.hasPrefix(areaPrefix)
            }
            
            if normalizedQuery.count == 5, let queryNumber = Int(normalizedQuery) {
                return isNumberInWildcardRange(number: queryNumber, prefix: areaPrefix)
            }
            
            return normalizedQuery.hasPrefix(areaPrefix) || areaPrefix.hasPrefix(normalizedQuery)
        }
        
        if normalizedQuery.hasSuffix("*") {
            let queryPrefix = String(normalizedQuery.dropLast())
            return normalizedArea.hasPrefix(queryPrefix)
        }
        
        return normalizedArea == normalizedQuery || normalizedArea.hasPrefix(normalizedQuery)
    }
    
    private func isNumberInWildcardRange(number: Int, prefix: String) -> Bool {
        guard let prefixNumber = Int(prefix) else { return false }
        
        let prefixLength = prefix.count
        guard prefixLength <= 4 else { return false }
        
        let multiplier = Int(pow(10.0, Double(5 - prefixLength)))
        let rangeStart = prefixNumber * multiplier
        let rangeEnd = rangeStart + multiplier - 1
        
        return number >= rangeStart && number <= rangeEnd
    }
}
