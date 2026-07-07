import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 24)
                Text("Studyloan Pro")
                    .font(Theme.titleFont)
                Text("Combined payoff projection and interest-paid totals")
                    .font(Theme.bodyFont)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                Spacer()
                Button {
                    Task { await purchases.purchase() }
                } label: {
                    Text("Unlock Pro — \(purchases.product?.displayPrice ?? "$1.99/mo")")
                        .font(Theme.bodyFont.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier("paywall_purchase_button")
                .padding(.horizontal)

                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .accessibilityIdentifier("paywall_restore_button")
                .font(Theme.captionFont)
                .padding(.bottom, 24)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("paywall_close_button")
                }
            }
        }
    }
}
