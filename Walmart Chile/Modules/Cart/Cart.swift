//
//  Cart.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import Foundation

extension Notification.Name {
    static let cartDidUpdate = Notification.Name("CartDidUpdate")
}

final class Cart {
    var updateAllowed = true
    var items: [Product: Int] = [:]
    var button: BadgeButton?
}

extension Cart {
    var totalAmout: Double {
        var amount = 0.0
        for item in items {
            amount += item.key.price * Double(item.value)
        }
        return amount
    }
    
    func quantityOfProducts() -> Int {
        items.compactMap { $0.value }.reduce(0, +)
    }
    
    func quantityOf(product: Product) -> Int {
        return items[product] ?? 0
    }
    
    func increase(product: Product) {
        if items[product] == nil {
            items[product] = 1
        } else {
            items[product] = quantityOf(product: product) + 1
        }
        NotificationCenter.default.post(name: .cartDidUpdate, object: product)
    }
    
    func decrease(product: Product) {
        if quantityOf(product: product) == 1{
            items[product] = nil
        } else {
            items[product] = quantityOf(product: product) - 1
        }
        NotificationCenter.default.post(name: .cartDidUpdate, object: product)
    }
    
    func itemList() -> [Product] {
        var list = [Product]()
        for item in items {
            list.append(item.key)
        }
        return list
    }
}
