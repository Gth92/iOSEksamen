
import Foundation

struct APIMeal: Identifiable, Codable {
    let idMeal: String
    let strMeal: String
    let strArea: String?
    let strCategory: String?
    let strMealThumb: String?
    let strInstructions: String?
    var id: String { idMeal }
}

struct APIResponse: Codable {
    let meals: [APIMeal]?
}

struct CategoryResponse: Codable {
    let categories: [APICategory]
}

struct APICategory: Codable {
    let idCategory: String
    let strCategory: String
    let imageCategory: String?
    let descriptionCategory: String?
}

struct AreaResponse: Codable {
    let meals: [APIArea]
}

struct APIArea: Codable {
    let strArea: String
}

struct IngredientResponse: Codable {
    let meals: [APIIngredient]
}

struct APIIngredient: Identifiable, Codable {
    let strIngredient: String
    var id: String { strIngredient }
}

