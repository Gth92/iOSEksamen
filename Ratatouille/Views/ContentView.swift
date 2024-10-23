
import SwiftUI


struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init() {
        if let storedIsDarkMode = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
            self._isDarkMode.wrappedValue = storedIsDarkMode
        }
    }
    
    var body: some View {
        MainTabView()
    }
    
}


#Preview {
    ContentView()
}
