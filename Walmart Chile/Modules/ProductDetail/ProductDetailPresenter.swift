//
//  ProductDetailPresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol ProductDetailPresenterDelegate {
    func viewDidLoad()
    func downloadImage(product: Product, imageView: UIImageView)
    func increase()
    func decrease()
}

final class ProductDetailPresenter {
    var viewController: UIViewController {
        guard let _viewController else {
            let productDetailViewController = ProductDetailViewController(presenter: self)
            delegate = productDetailViewController
            delegate?.reloadView(with: selectedProduct, quantityInCart: cart.quantityOf(product: selectedProduct), isLoading: true)
            return productDetailViewController
        }
        return _viewController
    }
    private var _viewController: UIViewController?
    
    private var selectedProduct: Product {
        didSet {
            delegate?.reloadView(with: selectedProduct, quantityInCart: cart.quantityOf(product: selectedProduct), isLoading: false)
        }
    }
    
    private var delegate: ProductDetailViewControllerDelegate?
    
    private var networkManager: ProductDetailNetworkManager
    
    private var cart: Cart
    
    required init(product: Product, cart: Cart) {
        self.selectedProduct = product
        self.cart = cart
        self.networkManager = ProductDetailNetworkManager()
    }
}

private extension ProductDetailPresenter {
    func loadProduct() {
        networkManager.getProduct(productID: "\(self.selectedProduct.id)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let product):
                self.selectedProduct = product
            case .failure(let error):
                // TODO: show error
                debugPrint(error)
                break
            }
        }
    }
}

extension ProductDetailPresenter: ProductDetailPresenterDelegate {
    func downloadImage(product: Product, imageView: UIImageView) {
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
    
    func viewDidLoad() {
        loadProduct()
    }
    
    func increase() {
        cart.increase(product: selectedProduct)
        delegate?.reloadView(with: selectedProduct, quantityInCart: cart.quantityOf(product: selectedProduct), isLoading: false)
    }
    
    func decrease() {
        cart.decrease(product: selectedProduct)
        delegate?.reloadView(with: selectedProduct, quantityInCart: cart.quantityOf(product: selectedProduct), isLoading: false)
    }
}
