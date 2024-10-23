

import SwiftUI

struct LogoNavigationBarView: View {
    var body: some View {
        HStack {
            Image("Ratata")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
        }
        .padding(.top, 30)
    }
}

#Preview {
    LogoNavigationBarView()
}
