//
//  ShimmerEffect.swift
//  Remius
//
//  Created by rafael.loggiodice on 6/1/26.
//

import SwiftUI

struct ShimmerEffect: ViewModifier {
    var firstColor: Color
    var secondColor: Color
    var thirdColor: Color

    @State var startPoint: UnitPoint = .init(x: -2.5, y: -2.5)
    @State var endPoint: UnitPoint = .init(x: -0.5, y: -0.5)

    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [
                        firstColor,
                        secondColor,
                        thirdColor
                    ],
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: false)
                    ) {
                        startPoint = .init(x: 1.5, y: 1.5)
                        endPoint = .init(x: 3.5, y: 3.5)
                    }
                }
            }
    }
}

#Preview("Default color gray") {
    Rectangle()
        .fill(Color.gray)
        .shimmerEffect()
        .clipShape(.rect(cornerRadius: 15))
}

#Preview("Different color") {
    RoundedRectangle(cornerRadius: 10)
        .frame(width: 240, height: 280)
        .shimmerEffect(firstColor: .yellow, secondColor: .red, thirdColor: .yellow)
        .clipShape(.rect(cornerRadius: 15))
}
