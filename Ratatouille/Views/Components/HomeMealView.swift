
import SwiftUI
import CoreData

struct HomeMealView: View {
    let meal: Meal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: meal.mealImage ?? "")) { image in
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

                Text(meal.mealName ?? "Unknown Meal")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Category: \(meal.category ?? "N/A")")
                    .opacity(0.6)
                    .font(.subheadline)
                Text("Area: \(meal.area ?? "N/A")")
                    .opacity(0.6)
                    .font(.subheadline)
                Divider()
                Text(meal.mealInstructions ?? "No Instructions")
                    .fontWeight(.thin)
            }
            .padding()
        }
    }
}


struct HomeMealView_Previews: PreviewProvider {
    static var previews: some View {
        
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        fetchRequest.fetchLimit = 1

        
        let context = PersistenceController.preview.container.viewContext
        let sampleMeals = try? context.fetch(fetchRequest)
        let sampleMeal = sampleMeals?.first ?? Meal(context: context)

        return HomeMealView(meal: sampleMeal)
    }
}

