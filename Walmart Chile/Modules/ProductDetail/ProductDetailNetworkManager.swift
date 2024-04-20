//
//  ProductDetailNetworkManager.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import Foundation

final class ProductDetailNetworkManager: NetworkManager {
    func getProduct(productID: String, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        get(paths: ["products", productID],type: Product.self) { result in
            switch result {
            case .success(let product):
                completion(.success(product))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
