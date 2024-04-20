//
//  HomePresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

protocol HomePresenterDelegate {
    func viewDidAppear(_ animated: Bool)
    func loadProducts(from category: String?)
}

final class HomePresenter {
    var viewController: UIViewController {
        guard let _viewController else {
            let homeViewController = HomeViewController(presenter: self, cart: cart)
            let navigationController = UINavigationController(rootViewController: homeViewController)
            delegate = homeViewController
            _viewController = navigationController
            return navigationController
        }
        return _viewController
    }
    private var _viewController: UIViewController?
    
    private var delegate: HomeViewControllerDelegate?
    private var cart: Cart
    private var networkManager: HomeNetworkManager
    private var productsDataSource: ProductsDataSource? {
        didSet {
            guard let productsDataSource else { return }
            delegate?.setDataSource(productsDataSource)
        }
    }
    
    required init(cart: Cart) {
        self.cart = cart
        self.networkManager = HomeNetworkManager()
    }
}

extension HomePresenter: HomePresenterDelegate {
    func loadProducts(from category: String? = nil) {
        networkManager.getProducts(from: category) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let products):
                self.productsDataSource = ProductsDataSource(products: products, delegate: self)
            case .failure(let error):
                // TODO: show error
                debugPrint(error)
                break
            }
        }
    }
    
    func viewDidAppear(_ animated: Bool) {
        loadProducts()
    }
}

extension HomePresenter: ProductCellDelegate {
    func increase(product: Product?, animatedImage: UIImageView) {
        guard let product, cart.updateAllowed else { return }
        if cart.quantityOf(product: product) == 0 {
            cart.updateAllowed = false
            delegate?.flyOverToCart(imageView: animatedImage, completion: { [weak self] in
                guard let self else { return }
                self.cart.increase(product: product)
                cart.updateAllowed = true
            })
            return
        }
        cart.increase(product: product)
    }
    
    func decrease(product: Product?) {
        guard let product, cart.updateAllowed else { return }
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
        guard let product else { return }
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
