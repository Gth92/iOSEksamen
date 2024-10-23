
import SwiftUI

struct SettingsIngredientView: View {
    
    @State private var ingredients = ["Salt", "Pepper", "Olive Oil", "Garlic", "Onion", "Tomato", "Basil", "Parsley", "Thyme", "Rosemary"]

    var body: some View {
        List {
            ForEach(ingredients, id: \.self) { ingredient in
                Text(ingredient)
            }
            .onDelete(perform: deleteIngredient)
        }
        .navigationTitle("Ingredients")
    }

    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
}


#Preview {
    SettingsIngredientView()
}

