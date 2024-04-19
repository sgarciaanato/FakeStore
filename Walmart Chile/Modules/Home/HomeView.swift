//
//  HomeView.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class HomeView: UIView {
    lazy var featuredProductView: FeaturedProductView = {
        let view = FeaturedProductView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return collectionView
    }()
    
    lazy var compositionalLayout: ProductsCompositionalLayout = {
        let layout = ProductsCompositionalLayout()
        return layout
    }()
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeView {
    func configureViews() {
        addSubview(featuredProductView)
        addSubview(collectionView)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            featuredProductView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            featuredProductView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            featuredProductView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: featuredProductView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeView {
    func setDataSource(_ dataSource: ProductsDataSource) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.featuredProductView.setProduct(dataSource.featuredProduct)
            self.collectionView.dataSource = dataSource
            self.collectionView.reloadData()
        }
    }
}


extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath)
        return cell
    }
}
