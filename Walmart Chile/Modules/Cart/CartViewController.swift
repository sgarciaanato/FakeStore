//
//  CartViewController.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CartViewControllerDelegate {
    
}

final class CartViewController: UIViewController {
    let presenter: CartPresenterDelegate
    
    lazy var cartView: CartView = {
        let view = CartView(delegate: self)
        return view
    }()
    
    required init(presenter: CartPresenterDelegate) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Cart"
    }
    
    override func loadView() {
        super.loadView()
        view = cartView
    }
}

extension CartViewController: CartViewControllerDelegate {
    
}

extension CartViewController: CartViewDelegate {
    var cart: Cart { presenter.cart }
}
