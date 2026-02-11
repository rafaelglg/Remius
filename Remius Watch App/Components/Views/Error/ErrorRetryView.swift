//
//  ErrorRetryView.swift
//  Remius
//
//  Created by Rafael Loggiodice on 8/2/26.
//

import SwiftUI

// MARK: - Error View Component
struct ErrorRetryView: View {
    var systemName: String = "exclamationmark.triangle.fill"
    var title: String = "flight.error.generic.title"

    let onRetry: @Sendable () async -> Void

    @State private var isRetrying = false

    var body: some View {
        VStack(spacing: .xSmall) {
            Spacer()
            errorIcon

            VStack(spacing: .xxSmall) {
                titleSection
                retrySection
            }
        }
    }

    var errorIcon: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.2))
                .frame(size: .sizeXLarge)

            Group {
                if isRetrying {
                    ProgressView()
                        .tint(.red)
                } else {
                    Image(systemName: systemName)
                        .resizable()
                }
            }
            .scaledToFit()
            .frame(size: .sizeMedium)
            .foregroundStyle(.red.gradient)
        }
        .glassEffect(.regular.tint(.red.opacity(0.2)))
        .toAnyButton(option: .any, action: onTapAnimation)
        .disabled(isRetrying)
    }

    var titleSection: some View {
        Text(LocalizedStringResource(stringLiteral: title))
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }

    var retrySection: some View {
        Text(isRetrying ? "flight.error.loading" : "flight.error.tapToRetry")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .contentTransition(.numericText(value: isRetrying ? 1 : 0))
    }

    func onTapAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
            isRetrying = true
        }

        Task {
            await onRetry()
            withAnimation(.easeInOut(duration: 0.3)) {
                isRetrying = false
            }
        }
    }
}

#Preview {
    ScrollView {
        ErrorRetryView(title: "flight.error.internet.title") {
            try? await Task.sleep(for: .seconds(2))
        }
    }
    .scrollBounceBehavior(.basedOnSize)
}
