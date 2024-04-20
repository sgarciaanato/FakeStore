//
//  HomePresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

protocol HomePresenterDelegate {
    var cart: Cart { get }
    func viewDidLoad()
    func loadProducts(from category: String?)
}

final class HomePresenter {
    var viewController: UIViewController {
        guard let _viewController else {
            let homeViewController = HomeViewController(presenter: self, cart: _cart)
            let navigationController = UINavigationController(rootViewController: homeViewController)
            delegate = homeViewController
            _viewController = navigationController
            return navigationController
        }
        return _viewController
    }
    private var _viewController: UIViewController?
    
    private var delegate: HomeViewControllerDelegate?
    private var _cart: Cart
    private var networkManager: HomeNetworkManager
    private var productsDataSource: ProductsDataSource? {
        didSet {
            guard let productsDataSource else { return }
            delegate?.setDataSource(productsDataSource)
        }
    }
    
    required init(cart: Cart) {
        _cart = cart
        self.networkManager = HomeNetworkManager()
    }
}

extension HomePresenter: HomePresenterDelegate {
    var cart: Cart { _cart }
    
    func loadProducts(from category: String? = nil) {
        self.productsDataSource = ProductsDataSource(products: [], isLoading: true, delegate: self)
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
    
    func viewDidLoad() {
        loadProducts()
    }
}

extension HomePresenter: ProductCellDelegate {
    func increase(product: Product?, animatedImage: UIImageView) {
        guard let product, _cart.updateAllowed else { return }
        if _cart.quantityOf(product: product) == 0 {
            _cart.updateAllowed = false
            delegate?.flyOverToCart(imageView: animatedImage, completion: { [weak self] in
                guard let self else { return }
                self._cart.increase(product: product)
                _cart.updateAllowed = true
            })
            return
        }
        _cart.increase(product: product)
    }
    
    func decrease(product: Product?) {
        guard let product, _cart.updateAllowed else { return }
        _cart.decrease(product: product)
    }
    
    func select(product: Product?) {
        guard let product else { return }
        delegate?.open(product)
    }
    
    func quantityOf(product: Product?) -> Int {
        guard let product else { return 0 }
        return _cart.quantityOf(product: product)
    }
    
    func downloadImage(product: Product?, imageView: UIImageView) {
        guard let product else { return }
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
