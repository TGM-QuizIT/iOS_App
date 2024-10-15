import SwiftUI

struct CustomLoading: View {
    @State private var leftBallOffset: CGFloat = -5 // Startpunkt der linken Kugel
    @State private var rightBallOffset: CGFloat = 5 // Startpunkt der rechten Kugel

    var body: some View {
        ZStack {
            Circle() // Linke Kugel
                .fill(Color.black)
                .frame(width: 10, height: 10)
                .offset(x: leftBallOffset) // Position abhängig vom Offset
            
            Circle() // Rechte Kugel
                .fill(Color.accentColor)
                .frame(width: 10, height: 10)
                .offset(x: rightBallOffset) // Position abhängig vom Offset
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            leftBallOffset = -5
            rightBallOffset = 5
        }
    }
    
    // Funktion zur Steuerung der Animation
    private func startAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            leftBallOffset = 5 // Die linke Kugel bewegt sich nach rechts
            rightBallOffset = -5 // Die rechte Kugel bewegt sich nach links
        }
    }
}

#Preview {
    CustomLoading()
}
