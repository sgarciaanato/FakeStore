//
//  CategoriesNetworkManager.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import Foundation

final class CategoriesNetworkManager: NetworkManager {
    func getCategories(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        get(paths: ["products", "categories"],type: [String].self) { result in
            switch result {
            case .success(let categories):
                completion(.success(categories))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
