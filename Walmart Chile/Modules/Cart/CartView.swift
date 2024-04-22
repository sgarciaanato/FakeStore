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
    func dismiss(success: Bool)
}

final class CartView: UIView {
    var delegate: CartViewDelegate
    
    enum CartSection {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<CartSection, CartItem>?
    
    lazy var emptyCartImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "EmptyCart")
        return image
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CartCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CartItemCell.self, forCellWithReuseIdentifier: CartItemCell.identifier)
        return collectionView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .secondarySystemBackground
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSizeMake(3, 3)
        view.layer.shadowRadius = 1
        return view
    }()
    
    lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: String(localized: "TotalAmout"), arguments: [String(format: "%.2f", delegate.cart.totalAmout)])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Purchase"), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(purchase), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.cornerRadius
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = Constants.buttonInsets
        button.configuration = configuration
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
    enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let margin: CGFloat = 6.0
        static let spacing: CGFloat = 12.0
        static let buttonInsets: NSDirectionalEdgeInsets = .init(top: 10.0, leading: 46.0, bottom: 10.0, trailing: 46.0)
    }
    
    func configureViews() {
        addSubview(collectionView)
        addSubview(emptyCartImage)
        addSubview(footerView)
        footerView.addSubview(totalAmountLabel)
        footerView.addSubview(purchaseButton)
        configureConstraints()
        backgroundColor = .systemBackground
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            emptyCartImage.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5),
            emptyCartImage.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.4),
            emptyCartImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyCartImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.margin),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.margin),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.cornerRadius),
            
            totalAmountLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: Constants.spacing),
            totalAmountLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            totalAmountLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            
            purchaseButton.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: Constants.spacing),
            purchaseButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
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
        
        let totalAmount = delegate.cart.totalAmout
        emptyCartImage.isHidden = totalAmount > 0
        collectionView.isHidden = totalAmount <= 0
        if totalAmount > 0  {
            totalAmountLabel.text = String(format: String(localized: "TotalAmout"), arguments: [String(format: "%.2f", delegate.cart.totalAmout)])
            purchaseButton.isEnabled = true
            return
        }
        totalAmountLabel.text = String(localized: "EmptyCart")
        purchaseButton.isEnabled = false
    }
    
    @objc func purchase() {
        delegate.cart.purchase()
        delegate.dismiss(success: true)
    }
}
