//
//  View+EXT.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//

import SwiftUI

extension View {

    /// Sets both width and height to the same size value
    /// - Parameter size: The size to apply to both width and height
    /// - Returns: A view with the specified width and height
    func frame(size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

    func shimmerEffect(
        firstColor: Color = Color(uiColor: UIColor.mySystemGray5),
        secondColor: Color = Color(uiColor: UIColor.mySystemGray6),
        thirdColor: Color = Color(uiColor: UIColor.mySystemGray5)
    ) -> some View {
        modifier(
            ShimmerEffect(
                firstColor: firstColor,
                secondColor: secondColor,
                thirdColor: thirdColor
            )
        )
    }

    func callToActionButton(backgroundColor: Color? = nil, role: ButtonRole? = nil) -> some View {
        self
            .font(.headline)
            .foregroundStyle(role == .destructive ? .red : .white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(backgroundColor ?? .red, in: RoundedRectangle(cornerRadius: 16))
    }

    func removeListRowFormatting() -> AnyView {
        listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .toAnyView()
    }

    func toAnyView() -> AnyView {
        AnyView(self)
    }

    func addingGradientBackgroundForText() -> some View {
        background(
            LinearGradient(colors: [
                Color.black.opacity(0),
                Color.black.opacity(0.5),
                Color.black.opacity(0.7)
            ], startPoint: .top, endPoint: .bottom)
        )
    }
}
