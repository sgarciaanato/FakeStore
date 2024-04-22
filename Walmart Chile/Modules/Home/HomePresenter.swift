//
//  HomePresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

protocol HomePresenterDelegate {
    var productCellDelegate: ProductCellDelegate { get }
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
    private var _isLoading: Bool
    private var _viewController: UIViewController?
    
    private var delegate: HomeViewControllerDelegate?
    private var _cart: Cart
    private var networkManager: HomeNetworkManager
    private var _products: [Product] {
        didSet {
            delegate?.updateDataSource()
        }
    }
    
    required init(cart: Cart) {
        _isLoading = true
        _cart = cart
        networkManager = HomeNetworkManager()
        _products = []
    }
}

extension HomePresenter: HomePresenterDelegate {
    var cart: Cart { _cart }
    var productCellDelegate: ProductCellDelegate { self }
    
    func loadProducts(from category: String? = nil) {
        _isLoading = true
        _products = getLoadingProducts()
        networkManager.getProducts(from: category) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let products):
                _isLoading = false
                self._products = reorder(products)
            case .failure(let error):
                delegate?.showError(error)
                break
            }
        }
    }
    
    func viewDidLoad() {
        loadProducts()
    }
}

extension HomePresenter: ProductCellDelegate {
    var isLoading: Bool { _isLoading }
    var products: [Product] { _products }
    
    func increase(product: Product?, animatedImage: UIImageView) {
        guard let product else { return }
        if _cart.quantityOf(product: product) == 0 {
            self._cart.increase(product: product)
            delegate?.flyOverToCart(imageView: animatedImage)
            return
        }
        _cart.increase(product: product)
    }
    
    func decrease(product: Product?) {
        guard let product else { return }
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
            case .failure:
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "ErrorImage")
                }
            }
        }
    }
    
    func reload() {
        loadProducts()
    }
}

private extension HomePresenter {
    func reorder(_ products: [Product]) -> [Product] {
        var prods = products
        if let featuredProduct = prods.max(by: { $0.rating.rate * $0.rating.count < $1.rating.rate * $1.rating.count }),
            let index = prods.firstIndex(of: featuredProduct) {
            let featuredProduct = prods.remove(at: index)
            prods.insert(featuredProduct, at: 0)
        }
        return prods
    }
    
    func getLoadingProducts() -> [Product] {
        return [
            Product(id: -1, title: "", price: 0.0, description: "", category: "", image: "", rating: Rating(rate: 0.0, count: 0.0)),
            Product(id: -2, title: "", price: 0.0, description: "", category: "", image: "", rating: Rating(rate: 0.0, count: 0.0)),
            Product(id: -3, title: "", price: 0.0, description: "", category: "", image: "", rating: Rating(rate: 0.0, count: 0.0)),
            Product(id: -4, title: "", price: 0.0, description: "", category: "", image: "", rating: Rating(rate: 0.0, count: 0.0)),
            Product(id: -5, title: "", price: 0.0, description: "", category: "", image: "", rating: Rating(rate: 0.0, count: 0.0))
        ]
    }
}
