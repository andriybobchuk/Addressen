import Foundation

struct Salesman: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let areas: [String]
    
    init(name: String, areas: [String]) {
        self.name = name
        self.areas = areas
    }
}

extension Salesman {
    var firstLetter: String {
        guard let first = name.first else { return "" }
        return String(first).uppercased()
    }
    
    var formattedAreas: String {
        areas.joined(separator: ", ")
    }
}
