//
//  Cart.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import Foundation

final class Cart {
    required init() {
        debugPrint("init cart")
    }
    
    deinit {
        debugPrint("Close")
    }
}

extension Cart {
    func addToCart() {
        debugPrint("add")
    }
}
