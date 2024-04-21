//
//  Cache.swift
//  Walmart Chile
//
//  Created by Samuel García on 21-04-24.
//

import Foundation

final class Cache {
    func getData(from urlString: String) -> Data? {
        return UserDefaults.standard.data(forKey: urlString)
    }
    
    func storeData(_ data: Data, to urlString: String) {
        UserDefaults.standard.set(data, forKey: urlString)
    }
}
