
import UIKit

struct MealDBApiClient {
    
    
    func fetchCategories(completion: @escaping (Result<CategoryResponse, Error>) -> Void) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        fetchData(url: url, completion: completion)
    }
    
    
    func fetchAreas(completion: @escaping (Result<AreaResponse, Error>) -> Void) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?a=list")!
        fetchData(url: url, completion: completion)
    }
    
    
    func fetchIngredients(completion: @escaping (Result<IngredientResponse, Error>) -> Void) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?i=list")!
        fetchData(url: url, completion: completion)
    }
    
    
    func searchMealsByName(_ name: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(name)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        fetchData(url: url, completion: completion)
    }
    
    
    func fetchMealsByArea(_ area: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?a=\(area)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        fetchData(url: url, completion: completion)
    }
    
    
    func fetchMealsByCategory(_ category: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        fetchData(url: url, completion: completion)
    }
    
    
    func fetchMealsByIngredient(_ ingredient: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?i=\(ingredient)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        fetchData(url: url, completion: completion)
    }
    
    
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
    }
    
    
}

func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(error ?? NSError(domain: "Network error", code: -1, userInfo: nil)))
            return
        }
        
        if let image = UIImage(data: data) {
            completion(.success(image))
        } else {
            completion(.failure(NSError(domain: "Invalid image data", code: -1, userInfo: nil)))
        }
    }.resume()
}


private func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(error ?? NSError(domain: "Network error", code: -1, userInfo: nil)))
            return
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

