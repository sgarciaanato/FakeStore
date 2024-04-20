//
//  Product.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

struct Product: Decodable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Rating: Decodable {
    let rate: Double
    let count: Double
}
