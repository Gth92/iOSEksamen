

import SwiftUI
import CoreData

struct RecipesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.mealName, ascending: true)],
        predicate: NSPredicate(format: "isArchived == %@", NSNumber(value: false)),
        animation: .default)
    private var meals: FetchedResults<Meal>
    
    var body: some View {
        NavigationView {
            if meals.isEmpty {
                VStack {
                    Spacer()
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                    Text("Ingen matoppskrifter")
                        .font(.headline)
                        .fontWeight(.heavy)
                    Spacer()
                        
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        LogoNavigationBarView()
                    }
                }
            } else {
                List {
                    ForEach(meals) { meal in
                        NavigationLink {
                            HomeMealView(meal: meal)
                        } label: {
                            HStack{
                                AsyncImage(url: URL(string: meal.mealImage ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                }
                                VStack(alignment: .leading) {
                                    Text(meal.mealName ?? "name")
                                        .font(.headline)
                                    
                                    Text(meal.area ?? "Ukjent kategori")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                if meal.isFavorite{
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(action: {
                                archiveMeal(meal: meal)
                            }) {
                                Label("", systemImage: "archivebox.fill")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                favoriteMeal(meal: meal)
                            }) {
                                Label("", systemImage: "star.fill")
                            }
                            .tint(.yellow)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        LogoNavigationBarView()
                    }
                }
            }
            
        }
    }
    
    private func archiveMeal(meal: Meal) {
        withAnimation {
            meal.isArchived = true
            do {
                try viewContext.save()
                print("\(meal.mealName ?? "Meal"): is archived")
            } catch {
                print("Error archiving meal: \(error)")
            }
        }
    }
    
    private func favoriteMeal(meal: Meal) {
        withAnimation {
            meal.isFavorite = !meal.isFavorite
            do {
                try viewContext.save()
                print("\(meal.mealName ?? "Meal"): marked as \(meal.isFavorite)")
            } catch {
                print("Error archiving meal: \(error)")
            }
        }
    }
    
}


#Preview {
    RecipesView()
}
