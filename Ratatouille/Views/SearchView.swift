import SwiftUI
import CoreData

enum SearchType: String, CaseIterable, Identifiable {
    case area = "Area"
    case category = "Category"
    case ingredient = "Ingredient"
    case text = "Text"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .area:
            return "globe"
        case .category:
            return "book"
        case .ingredient:
            return "carrot"
        case .text:
            return "magnifyingglass"
        }
    }
}

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Area.areaName, ascending: true)])
    private var areas: FetchedResults<Area>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.categoryName, ascending: true)])
    private var categories: FetchedResults<Category>
    
    @StateObject private var viewModel = ControllerModel(context: PersistenceController.shared.container.viewContext)
    
    @State private var searchType: SearchType = .text
    @State private var searchText = ""
    @State private var selectedArea: String = ""
    @State private var selectedCategory: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Search Type", selection: $searchType) {
                    ForEach(SearchType.allCases) { type in
                        Image(systemName: type.icon).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                switch searchType {
                case .area:
                    Menu("Landområde") {
                        ForEach(areas, id: \.self) { area in
                            Button(area.areaName ?? "Unknown") {
                                selectedArea = area.areaName ?? ""
                                viewModel.searchMealsByArea(selectedArea)
                            }
                        }
                    }
                case .category:
                    Menu("Kategori") {
                        ForEach(categories, id: \.self) { category in
                            Button(category.categoryName ?? "Unknown") {
                                selectedCategory = category.categoryName ?? ""
                                viewModel.searchMealsByCategory(selectedCategory)
                            }
                        }
                    }
                    
                case .ingredient:
                    TextField("Søk ingredienser", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit { viewModel.searchMealsByText(searchText) }
                case .text:
                    TextField("Søk", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit { viewModel.searchMealsByText(searchText) }
                }
                List {
                    ForEach(viewModel.meals, id: \.idMeal) { meal in
                        NavigationLink {
                            RecipeDetailView(meal: meal)
                        } label: {
                            AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
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
                                Text(meal.strMeal)
                                    .font(.headline)
                                
                                Text(meal.strArea ?? "Ukjent kategori")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(action: {
                                saveMeal(apiMeal: meal)
                            }) {
                                Label("Lagre", systemImage: "archivebox.fill")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Søk oppskrifter")
        .onAppear {
            viewModel.loadMeals()
            viewModel.fetchAndSaveAreas()
            viewModel.fetchAndSaveCategories()
        }
    }
    
    private func saveMeal(apiMeal: APIMeal) {
        let savedMeal = Meal(context: viewContext)
        savedMeal.mealId = apiMeal.idMeal
        savedMeal.mealName = apiMeal.strMeal
        savedMeal.mealImage = apiMeal.strMealThumb
        savedMeal.mealInstructions = apiMeal.strInstructions
        savedMeal.area = apiMeal.strArea
        savedMeal.category = apiMeal.strCategory
        
        
        do {
            try viewContext.save()
            print("\(apiMeal.strMeal): Meal saved")
        } catch {
            print("Error saving meal: \(error)")
        }
        
    }
    
}


#Preview {
    SearchView()
}
