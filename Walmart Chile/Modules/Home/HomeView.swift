//
//  HomeView.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class HomeView: UIView {
    var productCellDelegate: ProductCellDelegate
    
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
    func configureViews() {
        addSubview(collectionView)
        configureConstraints()
        backgroundColor = .systemBackground
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeView {
    func updateDataSource() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.collectionView.updateDataSource()
        }
    }
}
