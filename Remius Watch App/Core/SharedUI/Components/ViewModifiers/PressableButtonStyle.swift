//
//  PressableButtonStyle.swift
//  Remius
//
//  Created by Rafael Loggiodice on 7/2/26.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case plain, press, any
}

extension View {

    @ViewBuilder
    func toAnyButton(option: ButtonStyleOption = .plain, progress: Bool = false, action: @escaping () -> Void) -> some View {
        switch option {
        case .plain:
            plainButton(progress: progress, action: action)
        case .press:
            pressableButton(progress: progress, action: action)
        case .any:
            anyButton(action: action)
        }
    }

    func anyButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(.plain)
    }

    private func plainButton(progress: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                if progress {
                    ProgressView()
                        .tint(.white)
                        .callToActionButton()
                } else {
                    self
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func pressableButton(progress: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                if progress {
                    ProgressView()
                        .tint(.white)
                        .callToActionButton()
                } else {
                    self
                }
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    @Previewable @State var isLoading: Bool = false

    List {
        Group {

            Circle()
                .fill(.red.opacity(0.2).gradient)
                .frame(size: .sizeXLarge)
                .toAnyButton(option: .any) { }

            Text("plain")
                .callToActionButton()
                .toAnyButton { }

            Text("pressable")
                .callToActionButton()
                .toAnyButton(option: .press) { }

            Text("with loading")
                .callToActionButton(backgroundColor: .black)
                .toAnyButton(option: .plain, progress: true) { }

            Text("Destructive")
                .callToActionButton(backgroundColor: Color(uiColor: .mySystemGray5), role: .destructive)
                .toAnyButton(option: .press) { }

            Text("Blue color")
                .callToActionButton(backgroundColor: .blue)
                .toAnyButton(option: .press) { }

        }
        .padding()
    }
}
