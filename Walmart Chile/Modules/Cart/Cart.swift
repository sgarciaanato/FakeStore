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
    var updateAllowed: Bool
    var updatedItems: [Product]
    var items: [Product: Int]
    var button: BadgeButton?
    
    required init() {
        updateAllowed = true
        updatedItems = []
        guard let data = UserDefaults.standard.data(forKey: "CartItems") else {
            items = [:]
            return
        }
        let jsonDecoder = JSONDecoder()
        do {
            items = try jsonDecoder.decode([Product: Int].self, from: data)
        } catch(let error) {
            debugPrint(error)
            items = [:]
        }
    }
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
        if !updatedItems.contains(product) {
            updatedItems.append(product)
        }
        if items[product] == nil {
            items[product] = 1
        } else {
            items[product] = quantityOf(product: product) + 1
        }
        commitUpdate()
    }
    
    func decrease(product: Product) {
        if !updatedItems.contains(product) {
            updatedItems.append(product)
        }
        if quantityOf(product: product) == 1{
            items[product] = nil
        } else {
            items[product] = quantityOf(product: product) - 1
        }
        commitUpdate()
    }
    
    func commitUpdate() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(items)
            UserDefaults.standard.set(data, forKey: "CartItems")
        } catch(let error) {
            debugPrint(error)
        }
        NotificationCenter.default.post(name: .cartDidUpdate, object: nil, userInfo: ["ItemsToUpdate": updatedItems])
        updatedItems = []
    }
    
    func itemList() -> [Product] {
        var list = [Product]()
        for item in items {
            list.append(item.key)
        }
        return list
    }
    
    func purchase() {
        items = [:]
        commitUpdate()
    }
}
