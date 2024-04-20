//
//  CartItem.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import Foundation

struct CartItem: Hashable {
    let product: Product
    let quantity: Int
    
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.product.id == rhs.product.id && lhs.quantity == rhs.quantity
    }
}
