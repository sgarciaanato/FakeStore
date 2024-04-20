//
//  CartPresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CartPresenterDelegate {
    var cart: Cart { get }
    var cartItemDelegate: CartItemCellDelegate { get }
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
    private var networkManager: NetworkManager
    private var _cart: Cart
    
    required init(cart: Cart) {
        self.networkManager = NetworkManager()
        _cart = cart
    }
}

extension CartPresenter: CartPresenterDelegate {
    var cart: Cart { _cart }
    var cartItemDelegate: CartItemCellDelegate { self }
}

extension CartPresenter: CartItemCellDelegate {
    func increase(product: Product?, animatedImage: UIImageView) {
        guard let product else { return }
        cart.increase(product: product)
    }
    
    func decrease(product: Product?) {
        guard let product else { return }
        cart.decrease(product: product)
    }
    
    func select(product: Product?) {
        guard let product else { return }
        delegate?.open(product)
    }
    
    func quantityOf(product: Product?) -> Int {
        guard let product else { return 0 }
        return cart.quantityOf(product: product)
    }
    
    func downloadImage(product: Product?, imageView: UIImageView) {
        guard let product else { return  }
        imageView.image = nil
        networkManager.getImage(from: product.image) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                // TODO: show error
                debugPrint(error)
            }
        }
    }
}
