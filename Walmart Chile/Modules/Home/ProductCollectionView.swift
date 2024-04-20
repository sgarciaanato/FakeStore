//
//  ProductCollectionView.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class ProductCollectionView: UICollectionView {
    override var dataSource: UICollectionViewDataSource? {
        didSet {
            self.collectionViewLayout = createCompositionalLayout()
        }
    }
    
    required init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        register(FeaturedProductCell.self, forCellWithReuseIdentifier: FeaturedProductCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProductCollectionView {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            var group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3)), subitem: item, count: 2)
            if sectionIndex == 0 {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3)), subitem: item, count: 1)
            }
            return NSCollectionLayoutSection(group: group)
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        return layout
    }
}
