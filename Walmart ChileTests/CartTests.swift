//
//  CartTests.swift
//  Walmart ChileTests
//
//  Created by Samuel García on 21-04-24.
//

import XCTest
@testable import Walmart_Chile

final class CartTests: XCTestCase {
    
    var cart: Cart!
    let product1 = Product(id: 1, title: "", price: 10.0, description: "", category: "", image: "", rating: Rating(rate: 0.0, count: 0.0))
    let product2 = Product(id: 2, title: "", price: 100.0, description: "", category: "", image: "", rating: Rating(rate: 0.0, count: 0.0))

    override func setUp() async throws {
        cart = Cart()
        cart.items = [:]
    }
    
    func test_increaseProductQuantityTest() {
        XCTAssertEqual(cart.quantityOfProducts(), 0)
        XCTAssertEqual(cart.quantityOf(product: product1), 0)
        
        cart.increase(product: product1)
        XCTAssertEqual(cart.quantityOfProducts(), 1)
        XCTAssertEqual(cart.quantityOf(product: product1), 1)
        XCTAssertEqual(cart.quantityOf(product: product2), 0)
        
        cart.increase(product: product2)
        XCTAssertEqual(cart.quantityOfProducts(), 2)
        XCTAssertEqual(cart.quantityOf(product: product1), 1)
        XCTAssertEqual(cart.quantityOf(product: product2), 1)
        
        cart.increase(product: product2)
        XCTAssertEqual(cart.quantityOfProducts(), 3)
        XCTAssertEqual(cart.quantityOf(product: product1), 1)
        XCTAssertEqual(cart.quantityOf(product: product2), 2)
    }
    
    func test_decreaseProductQuantityTest() {
        cart.increase(product: product1)
        cart.increase(product: product2)
        cart.increase(product: product2)
        XCTAssertEqual(cart.quantityOfProducts(), 3)
        XCTAssertEqual(cart.quantityOf(product: product1), 1)
        XCTAssertEqual(cart.quantityOf(product: product2), 2)
        
        cart.decrease(product: product2)
        XCTAssertEqual(cart.quantityOfProducts(), 2)
        XCTAssertEqual(cart.quantityOf(product: product1), 1)
        XCTAssertEqual(cart.quantityOf(product: product2), 1)
        
        cart.decrease(product: product1)
        XCTAssertEqual(cart.quantityOfProducts(), 1)
        XCTAssertEqual(cart.quantityOf(product: product1), 0)
        XCTAssertEqual(cart.quantityOf(product: product2), 1)
        
        // remove product that is not in the cart to test that the cart does nothing
        cart.decrease(product: product1)
        XCTAssertEqual(cart.quantityOfProducts(), 1)
        XCTAssertEqual(cart.quantityOf(product: product1), 0)
        XCTAssertEqual(cart.quantityOf(product: product2), 1)
        
        cart.decrease(product: product2)
        XCTAssertEqual(cart.quantityOfProducts(), 0)
        XCTAssertEqual(cart.quantityOf(product: product1), 0)
        XCTAssertEqual(cart.quantityOf(product: product2), 0)
    }
    
    func test_totalAmoutSum() {
        XCTAssertEqual(cart.totalAmout, 0.0)
        
        cart.increase(product: product1)
        XCTAssertEqual(cart.totalAmout, 10.0)
        
        cart.increase(product: product2)
        XCTAssertEqual(cart.totalAmout, 110.0)
        
        cart.increase(product: product2)
        XCTAssertEqual(cart.totalAmout, 210.0)
    }
    
    func test_purchase() {
        cart.increase(product: product1)
        cart.increase(product: product2)
        cart.increase(product: product2)
        XCTAssertEqual(cart.totalAmout, 210.0)
        
        cart.purchase()
        XCTAssertEqual(cart.totalAmout, 0.0)
    }
    
}
