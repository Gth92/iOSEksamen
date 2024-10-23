
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
        
            RecipesView()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        LogoNavigationBarView()
                    }
                }
                .tabItem {
                    Label("Mine Oppskrifter", systemImage: "fork.knife.circle")
                }
            
            SearchView()
                .tabItem {
                    Label("Søk", systemImage: "magnifyingglass")
                }
            
            SettingsView()
                .tabItem {
                    Label("Innstillinger", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainTabView()
}
