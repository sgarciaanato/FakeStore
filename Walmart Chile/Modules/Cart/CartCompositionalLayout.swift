//
//  CartCompositionalLayout.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

final class CartCompositionalLayout: UICollectionViewCompositionalLayout {
    required init() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1 / 2)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
