
import SwiftUI
import CoreData

class ControllerModel: ObservableObject {
    @Published var meals = [APIMeal]()
    @Published var areas = [Area]()
    @Published var categories = [Category]()
    private var apiClient = MealDBApiClient()
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func loadMeals() {
        apiClient.searchMealsByName("Chicken") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apiResponse):
                    self?.meals = apiResponse.meals ?? []
                case .failure(let error):
                    print("Error fetching meals: \(error)")
                }
            }
        }
    }
    
    func searchMealsByArea(_ area: String) {
        apiClient.fetchMealsByArea(area) { [weak self] result in
            self?.handleSearchResult(result)
        }
    }
    
    func searchMealsByCategory(_ category: String) {
        apiClient.fetchMealsByCategory(category) { [weak self] result in
            self?.handleSearchResult(result)
        }
    }
    
    func searchMealsByIngredient(_ ingredient: String) {
        apiClient.fetchMealsByIngredient(ingredient) { [weak self] result in
            self?.handleSearchResult(result)
        }
    }
    
    func searchMealsByText(_ searchText: String) {
        apiClient.searchMealsByName(searchText) { [weak self] result in
            self?.handleSearchResult(result)
        }
    }
    
    func fetchAndSaveAreas() {
        apiClient.fetchAreas { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let areaResponse):
                    self?.saveAreas(areaResponse.meals)
                    print("Successfully fetched and saved areas: \(areaResponse.meals)")
                case .failure(let error):
                    print("Error fetching areas")
                }
            }
        }
    }
    
    func fetchAndSaveCategories() {
        apiClient.fetchCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categoryResponse):
                    self?.saveCategories(categoryResponse.categories)
                    print("Successfully fetched and saved categories: \(categoryResponse.categories)")
                case .failure(let error):
                    print("Error fetching categories")
                }
            }
        }
    }
    
    
    private func saveAreas(_ apiAreas: [APIArea]) {
        apiAreas.forEach { apiArea in
            let area = Area(context: viewContext)
            area.areaName = apiArea.strArea
        }
        saveContext()
    }
    
    private func saveCategories(_ apiCategories: [APICategory]) {
        apiCategories.forEach { categoryData in
            let category = Category(context: viewContext)
            category.categoryName = categoryData.strCategory
            category.categoryId = categoryData.idCategory
            category.categoryImage = categoryData.imageCategory
            category.categoryDescription = categoryData.descriptionCategory
        }
        saveContext()
    }
    
    private func handleSearchResult(_ result: Result<APIResponse, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let apiResponse):
                self.meals = apiResponse.meals ?? []
            case .failure(let error):
                print("Error fetching meals: \(error)")
            }
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

