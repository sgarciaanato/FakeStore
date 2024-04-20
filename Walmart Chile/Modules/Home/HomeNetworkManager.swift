//
//  HomeNetworkManager.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import Foundation

final class HomeNetworkManager: NetworkManager {
    func getProducts(from category: String? = nil, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        var paths: [String] = ["products"]
        if let category {
            paths.append("category")
            paths.append(category)
        }
        get(paths: paths, type: [Product].self) { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
