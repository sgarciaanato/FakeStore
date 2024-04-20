//
//  CartView.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CartViewDelegate {
    var cart: Cart { get }
}

final class CartView: UIView {
    var delegate: CartViewDelegate
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CartCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return collectionView
    }()
    
    lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total amount: $\(delegate.cart.totalAmout)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = "Purchase"
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
        collectionView.reloadData()
        totalAmountLabel.text = "Total amount: $\(delegate.cart.totalAmout)"
    }
}

extension CartView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate.cart.itemList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        let product = delegate.cart.itemList()[indexPath.row]
        cell.setProduct(product, quantityInCart: delegate.cart.quantityOf(product: product))
        return cell
    }
}
