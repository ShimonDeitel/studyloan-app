import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: LoanItem?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button {
                            editingItem = item
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.lender)
                                    .font(Theme.bodyFont.weight(.semibold))
                                Text("\(item.balance)")
                                    .font(Theme.captionFont)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .accessibilityIdentifier("item_row_\(item.id.uuidString)")
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Studyloan")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settings_gear_button")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("add_item_button")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddItemView { item in
                    store.add(item)
                }
            }
            .sheet(item: $editingItem) { item in
                EditItemView(item: item, onSave: { updated in
                    store.update(updated)
                }, onDelete: {
                    store.delete(item)
                })
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var lender: String = ""
    @State private var balanceText: String = ""
    @State private var interestRateText: String = ""
    @State private var nextPaymentDate: String = ""
    var onSave: (LoanItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("New Loan") {
                    TextField("Lender", text: $lender)
                        .accessibilityIdentifier("add_lender_field")
                    TextField("Balance", text: $balanceText)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("add_balance_field")
                    TextField("Interestrate", text: $interestRateText)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("add_interestRate_field")
                    TextField("Nextpaymentdate", text: $nextPaymentDate)
                        .accessibilityIdentifier("add_nextPaymentDate_field")
                }
            }
            .background(
                Color.clear.contentShape(Rectangle())
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
            .navigationTitle("Add Loan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("add_cancel_button")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = LoanItem(
                        lender: lender,
                        balance: Double(balanceText) ?? 0,
                        interestRate: Double(interestRateText) ?? 0,
                        nextPaymentDate: nextPaymentDate
                        )
                        onSave(item)
                        dismiss()
                    }
                    .accessibilityIdentifier("add_save_button")
                }
            }
        }
    }
}

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State var item: LoanItem
    var onSave: (LoanItem) -> Void
    var onDelete: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Loan") {
                    Text(item.lender)
                }
                Section {
                    Button("Delete", role: .destructive) {
                        onDelete()
                        dismiss()
                    }
                    .accessibilityIdentifier("edit_delete_button")
                }
            }
            .navigationTitle("Edit Loan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("edit_close_button")
                }
            }
        }
    }
}
