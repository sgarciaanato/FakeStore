//
//  HomeNetworkManager.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import Foundation

final class HomeNetworkManager: NetworkManager {
    func getProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        get(paths: [.products],type: [Product].self) { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
