//
//  HomeView.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class HomeView: UIView {
    var productCellDelegate: ProductCellDelegate
    
    lazy var purchaseView: PurchaseView = {
        let view = PurchaseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var collectionView: ProductCollectionView = {
        let collectionView = ProductCollectionView(productCellDelegate: productCellDelegate)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    required init(productCellDelegate: ProductCellDelegate) {
        self.productCellDelegate = productCellDelegate
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeView {
    enum Constants {
        static let animationDuration: CGFloat = 1.0
    }
    
    func configureViews() {
        addSubview(collectionView)
        addSubview(purchaseView)
        addSubview(errorView)
        configureConstraints()
        backgroundColor = .systemBackground
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            purchaseView.topAnchor.constraint(equalTo: topAnchor),
            purchaseView.leadingAnchor.constraint(equalTo: leadingAnchor),
            purchaseView.trailingAnchor.constraint(equalTo: trailingAnchor),
            purchaseView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension HomeView {
    func updateDataSource() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            errorView.isHidden = true
            collectionView.isHidden = false
            self.collectionView.updateDataSource()
        }
    }
    
    func showPurchaseView() {
        purchaseView.alpha = 0
        purchaseView.isHidden = false
        
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }
            purchaseView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: Constants.animationDuration, delay: Constants.animationDuration) { [weak self] in
                guard let self else { return }
                purchaseView.alpha = 0
            } completion: { [weak self] _ in
                guard let self else { return }
                purchaseView.isHidden = true
            }
        }
    }
    
    func showError(_ error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            errorView.error = error
            errorView.retry = { [weak self] in
                guard let self else { return }
                productCellDelegate.reload()
            }
            errorView.isHidden = false
            collectionView.isHidden = true
        }
    }
}
