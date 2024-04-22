//
//  HomeViewController.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

protocol CartDelegate {
    func showPurchaseView()
}

protocol CategorySelectionDelegate {
    func select(_ category: String?)
}

protocol HomeViewControllerDelegate {
    func updateDataSource()
    func flyOverToCart(imageView: UIImageView)
    func open(_ product: Product)
}

final class HomeViewController: UIViewController {
    let presenter: HomePresenterDelegate
    let cartButton: BadgeButton
    
    lazy var homeView: HomeView = {
        let view = HomeView(productCellDelegate: presenter.productCellDelegate)
        return view
    }()
    
    required init(presenter: HomePresenterDelegate, cart: Cart) {
        self.presenter = presenter
        cartButton = BadgeButton(cart: cart)
        cart.button = cartButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(openCategories))
        
        cartButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        cartButton.setImage(UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cartButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        cartButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartButton), categoryButton]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Walmart Chile"
        
        presenter.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        view = homeView
    }
}

private extension HomeViewController {
    @objc func openCategories() {
        let categoriesPresenter = CategoriesPresenter(categorySelectionDelegate: self)
        let categoriesViewController = categoriesPresenter.viewController
        categoriesViewController.modalPresentationStyle = .overCurrentContext
        present(categoriesViewController, animated: true, completion: nil)
    }
    
    @objc func openCart() {
        let cartPresenter = CartPresenter(cart: self.presenter.cart, cartDelegate: self)
        navigationController?.pushViewController(cartPresenter.viewController, animated: true)
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    func open(_ product: Product) {
        let productDetailPresenter = ProductDetailPresenter(product: product, cart: self.presenter.cart)
        present(productDetailPresenter.viewController, animated: true, completion: nil)
    }
    
    func updateDataSource() {
        homeView.updateDataSource()
    }
    
    func flyOverToCart(imageView: UIImageView) {
        guard let initialFrame = imageView.globalFrame, let finalFrame = cartButton.globalFrame else { return }
        let animatedImageView = UIImageView(frame: initialFrame)
        animatedImageView.layer.cornerRadius = 5
        animatedImageView.contentMode = .scaleAspectFit
        animatedImageView.image = imageView.image
        view.addSubview(animatedImageView)
        UIView.animate(withDuration: 0.3) {
            animatedImageView.frame = finalFrame
        } completion: { [weak self] _ in
            animatedImageView.removeFromSuperview()
            guard let self else { return }
            self.cartButton.transform = CGAffineTransform(translationX: 0, y: -5)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 3, options: .allowUserInteraction, animations: { [weak self] in
                guard let self else { return }
                self.cartButton.transform = CGAffineTransform.identity
            })
        }
        
    }
}

extension HomeViewController: CategorySelectionDelegate {
    func select(_ category: String?) {
        presenter.loadProducts(from: category)
    }
}

extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

extension HomeViewController: CartDelegate {
    func showPurchaseView() {
        homeView.showPurchaseView()
    }
}
