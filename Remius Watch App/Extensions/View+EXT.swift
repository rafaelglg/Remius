extension View {
    func shimmerEffect(
        firstColor: Color = Color(uiColor: UIColor.systemGray5),
        secondColor: Color = Color(uiColor: UIColor.systemGray6),
        thirdColor: Color = Color(uiColor: UIColor.systemGray5)
    ) -> some View {
        self.modifier(
            ShimmerEffect(
                firstColor: firstColor,
                secondColor: secondColor,
                thirdColor: thirdColor
            )
        )
    }
    
    func removeListRowFormatting() -> AnyView {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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