import Foundation

struct LoanItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var lender: String
    var balance: Double
    var interestRate: Double
    var nextPaymentDate: String
    var dateAdded: Date = Date()
}
