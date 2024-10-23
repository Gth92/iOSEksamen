
import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Generelt")) {
                    NavigationLink(destination: SettingsAreaView()) {
                        Label("Redigere landsområder", systemImage: "globe")
                    }
                    
                    NavigationLink(destination: SettingsCategoryView()) {
                        Label("Redigere kategorier", systemImage: "book")
                    }
                    
                    NavigationLink(destination: SettingsIngredientView()) {
                        Label("Redigere ingredienser", systemImage: "carrot")
                    }
                    
                }
                
                Section {
                    HStack {
                        Label("Aktiver mørk Modus", systemImage: isDarkMode ? "moon.fill" : "moon")
                        Spacer()
                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                    }
                }
                
                
                Section {
                    NavigationLink(destination: SettingsArchiveView()) {
                        Label("Administrere arkiv", systemImage: "folder")
                    }
                }
            }
            .navigationBarTitle("Innstillinger")
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    SettingsView()
}
