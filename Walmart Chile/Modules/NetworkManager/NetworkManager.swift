//
//  NetworkManager.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}

class NetworkManager {
    let useMock = false
    
    required init() {
        self.cache = Cache()
    }
    let cache: Cache
    
    private let baseURL = "https://fakestoreapi.com"
    
    func get<U: Decodable>(paths: [String], type: U.Type, completion: @escaping (Result<U, NetworkError>) -> Void) {
        guard let url = buildUrl(paths: paths) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let products = try JSONDecoder().decode(U.self, from: data)
                completion(.success(products))
            }
            catch {
                completion(.failure(.message(error)))
            }
        }.resume()
    }
    
    func getImage(from urlString:String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let imageCacheData = cache.getData(from: urlString) {
            completion(.success(imageCacheData))
            return
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            self.cache.storeData(data, to: urlString)
            completion(.success(data))
        }.resume()
    }
}

private extension NetworkManager {
    func buildUrl(paths: [String]) -> URL? {
        var stringUrl = baseURL
        for path in paths {
            stringUrl += "/\(path)"
        }
        return URL(string: stringUrl)
    }
}
