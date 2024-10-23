
import SwiftUI
import CoreData

struct SettingsCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var apiClient = MealDBApiClient()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.categoryName, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>

    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                Text(category.categoryName ?? "Unknown Category")
            }
            .onDelete(perform: deleteCategory)
        }
        .onAppear(perform: fetchAndSaveCategories)
        .navigationTitle("Categories")
    }

    private func fetchAndSaveCategories() {
        apiClient.fetchCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categoryResponse):
                    self.saveCategories(categoryResponse.categories)
                    print("Successfully fetched and saved categories: \(categoryResponse.categories)")
                case .failure(let error):
                    print("Error fetching categories")
                }
            }
        }
    }
    
    private func saveCategories(_ apiCategories: [APICategory]) {
        apiCategories.forEach { categoryData in
            let category = Category(context: viewContext)
            category.categoryName = categoryData.strCategory
            category.categoryId = categoryData.idCategory
            category.categoryImage = categoryData.imageCategory
            category.categoryDescription = categoryData.descriptionCategory
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            viewContext.delete(category)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting category: \(error)")
        }
    }
}

#Preview {
    SettingsCategoryView()
}

