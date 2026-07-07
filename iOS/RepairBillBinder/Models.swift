import Foundation

struct ReceiptEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var notes: String = ""
    var shop: String
    var cost: Double
}
