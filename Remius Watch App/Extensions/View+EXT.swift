//
//  View+EXT.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//

import SwiftUI

extension UIColor {
    static var mySystemGray5: UIColor {
        return .init(red: 229 / 255, green: 229 / 255, blue: 234 / 255, alpha: 1)
    }

    static var mySystemGray6: UIColor {
        return .init(red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1)
    }
}

extension View {
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
