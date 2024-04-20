//
//  CategoriesPresenter.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CategoriesPresenterDelegate {
    var categories: [String] { get }
    func viewDidLoad()
    func select(_ category: String?)
}

final class CategoriesPresenter {
    var viewController: UIViewController {
        guard let _viewController else {
            let categoriesViewController = CategoriesViewController(presenter: self)
            let navigationViewController = UINavigationController(rootViewController: categoriesViewController)
            delegate = categoriesViewController
            return navigationViewController
        }
        return _viewController
    }
    private var _viewController: UIViewController?
    
    private var delegate: CategoriesViewControllerDelegate?
    private var categorySelectionDelegate: CategorySelectionDelegate
    
    private var networkManager: CategoriesNetworkManager
    internal var categories: [String]
    
    required init(categorySelectionDelegate: CategorySelectionDelegate) {
        self.networkManager = CategoriesNetworkManager()
        self.categorySelectionDelegate = categorySelectionDelegate
        self.categories = []
    }
}

private extension CategoriesPresenter {
    func loadCategories() {
        networkManager.getCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                self.categories.insert("Todos", at: 0)
                delegate?.reloadData()
            case .failure(let error):
                // TODO: show error
                debugPrint(error)
                break
            }
        }
    }
}

extension CategoriesPresenter: CategoriesPresenterDelegate {
    func viewDidLoad() {
        loadCategories()
    }
    
    func select(_ category: String?) {
        categorySelectionDelegate.select(category)
    }
}
