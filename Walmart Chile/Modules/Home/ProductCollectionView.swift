//
//  ProductCollectionView.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class ProductCollectionView: UICollectionView {
    enum ProductSection {
        case featured
        case main
    }
    
    let productCellDelegate: ProductCellDelegate
    var productsDataSource: UICollectionViewDiffableDataSource<ProductSection, Product>?
    
    required init(productCellDelegate: ProductCellDelegate) {
        self.productCellDelegate = productCellDelegate
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = createCompositionalLayout()
        register(ShimmerCell.self, forCellWithReuseIdentifier: ShimmerCell.identifier)
        register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        register(FeaturedProductCell.self, forCellWithReuseIdentifier: FeaturedProductCell.identifier)
        self.productsDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            if productCellDelegate.isLoading {
                guard let shimmerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShimmerCell.identifier, for: indexPath) as? ShimmerCell else { return UICollectionViewCell() }
                return shimmerCell
            }
            
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedProductCell.identifier, for: indexPath) as? FeaturedProductCell else { return UICollectionViewCell() }
                cell.delegate = productCellDelegate
                let product = productCellDelegate.products[0]
                cell.setProduct(product, quantityInCart: productCellDelegate.quantityOf(product: product))
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
            cell.delegate = productCellDelegate
            let product = productCellDelegate.products[indexPath.row + 1]
            cell.setProduct(product, quantityInCart: productCellDelegate.quantityOf(product: product))
            return cell
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductCollectionView {
    func updateDataSource() {
        var products = productCellDelegate.products
        var snapshot = NSDiffableDataSourceSnapshot<ProductSection, Product>()
        guard products.count > 1 else {
            snapshot.appendSections([.featured])
            snapshot.appendItems(products)
            return
        }
        
        let featuredProduct = products.removeFirst()
        snapshot.appendSections([.featured])
        snapshot.appendItems([featuredProduct])
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        
        productsDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

private extension ProductCollectionView {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            var group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(9 / 12)), subitem: item, count: 2)
            if sectionIndex == 0 {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3 / 5)), subitem: item, count: 1)
            }
            return NSCollectionLayoutSection(group: group)
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        return layout
    }
}
