//
//  CartView.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CartViewDelegate {
    var cart: Cart { get }
    var cartItemDelegate: CartItemCellDelegate { get }
}

final class CartView: UIView {
    var delegate: CartViewDelegate
    
    enum CartSection {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<CartSection, CartItem>?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CartCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: CartItemCell.identifier)
        return collectionView
    }()
    
    lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total amount: $\(String(format: "%.2f", delegate.cart.totalAmout))"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Purchase", for: .normal)
        button.addTarget(self, action: #selector(purchase), for: .touchUpInside)
        return button
    }()
    
    lazy var compositionalLayout: CartCompositionalLayout = {
        let layout = CartCompositionalLayout()
        return layout
    }()
    
    required init(delegate: CartViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureViews()
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else { return UICollectionViewCell() }
            let product = delegate.cart.itemList()[indexPath.row]
            cell.delegate = delegate.cartItemDelegate
            let cartItem = CartItem(product: product, quantity: delegate.cart.quantityOf(product: product))
            cell.setCartItem(cartItem)
            return cell
        })
        updateCart()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCart), name: .cartDidUpdate, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension CartView {
    func configureViews() {
        addSubview(collectionView)
        addSubview(totalAmountLabel)
        addSubview(purchaseButton)
        configureConstraints()
        backgroundColor = .systemBackground
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            totalAmountLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            totalAmountLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            totalAmountLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            purchaseButton.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor),
            purchaseButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            purchaseButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            purchaseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func updateCart() {
        var cartItems = [CartItem]()
        for product in delegate.cart.items {
            cartItems.append(CartItem(product: product.key, quantity: product.value))
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<CartSection, CartItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cartItems)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func purchase() {
        delegate.cart.purchase()
    }
}
