import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [LoanItem] = []
    @Published var isPro: Bool = false

    static let freeLimit = 14

    private let fileName = "studyloan_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([LoanItem].self, from: data) else {
            items = [
        LoanItem(lender: "Federal Direct", balance: 18500.0, interestRate: 4.5, nextPaymentDate: "2026-08-01"),
        LoanItem(lender: "Sallie Mae", balance: 9200.0, interestRate: 6.8, nextPaymentDate: "2026-08-05")
            ]
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    @discardableResult
    func add(_ item: LoanItem) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: LoanItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: LoanItem) {
        items.removeAll(where: { $0.id == item.id })
        save()
    }
}
