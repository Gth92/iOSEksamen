
import SwiftUI

struct SplashView: View {
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            Image("RatatouilleImage")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .rotationEffect(rotationAngle)
                .onAppear {
                    withAnimation(Animation.linear(duration: 3)) {
                        self.rotationAngle = .degrees(360)
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
        }
        .fullScreenCover(isPresented: $isActive) {
            MainTabView() 
        }
    }
}

#Preview {
    SplashView()
}
