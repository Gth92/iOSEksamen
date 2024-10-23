
import SwiftUI

struct RecipeDetailView: View {
    let meal: APIMeal
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipped()
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .foregroundColor(.gray)
                }
                .cornerRadius(10)
                
                Text(meal.strMeal)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Category: \(meal.strCategory ?? "N/A")")
                    .opacity(0.6)
                    .font(.subheadline)
                Text("Area: \(meal.strArea ?? "N/A")")
                    .opacity(0.6)
                    .font(.subheadline)
                
                Divider()
                
                Text(meal.strInstructions ?? "No Instructions")
                    .fontWeight(.thin)
                
                
            }
            .padding()
        }
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        
        let sampleMeal = APIMeal(idMeal: "12345", strMeal: "Sample Meal", strArea: "https://via.placeholder.com/300", strCategory: "Sample Category", strMealThumb: "Sample Area", strInstructions: "Sample Instructions")

        RecipeDetailView(meal: sampleMeal)
    }
}
