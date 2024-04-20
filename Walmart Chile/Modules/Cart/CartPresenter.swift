//
//  CartPresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CartPresenterDelegate {
    var cart: Cart { get }
}

final class CartPresenter {
    var viewController: UIViewController {
        guard let _viewController else {
            let cartViewController = CartViewController(presenter: self)
            delegate = cartViewController
            return cartViewController
        }
        return _viewController
    }
    private var _viewController: UIViewController?
    private var delegate: CartViewControllerDelegate?
    private var _cart: Cart
    
    required init(cart: Cart) {
        _cart = cart
    }
}

extension CartPresenter: CartPresenterDelegate {
    var cart: Cart { _cart }
}
