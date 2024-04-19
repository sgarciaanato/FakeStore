//
//  HomePresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

protocol HomePresenterDelegate {
    func viewDidAppear(_ animated: Bool)
}

final class HomePresenter {
    var viewController: UIViewController {
        guard let _viewController else {
            let vc = HomeViewController(presenter: self)
            delegate = vc
            _viewController = vc
            return vc
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

private extension HomePresenter {
    func loadProducts() {
        networkManager.getProducts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let products):
                self.productsDataSource = ProductsDataSource(products: products)
            case .failure(let error):
                // TODO: show error
                debugPrint(error)
                break
            }
        }
    }
}

extension HomePresenter: HomePresenterDelegate {
    func viewDidAppear(_ animated: Bool) {
        loadProducts()
    }
}
