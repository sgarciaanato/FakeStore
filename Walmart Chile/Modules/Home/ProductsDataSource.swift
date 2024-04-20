//
//  ProductsDataSource.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class ProductsDataSource: NSObject, UICollectionViewDataSource {
    var products: [Product]
    var productCellDelegate: ProductCellDelegate
    var isLoading: Bool
    
    required init(products: [Product], isLoading: Bool = false, delegate: ProductCellDelegate) {
        self.products = products
        self.isLoading = isLoading
        self.productCellDelegate = delegate
        super.init()
        reorderProducts()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading { return 0 }
        if section == 0 {
            return 1
        }
        return products.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedProductCell.identifier, for: indexPath) as? FeaturedProductCell else { return UICollectionViewCell() }
            cell.delegate = productCellDelegate
            let product = products[0]
            cell.setProduct(product, quantityInCart: productCellDelegate.quantityOf(product: product))
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.delegate = productCellDelegate
        let product = products[indexPath.row + 1]
        cell.setProduct(product, quantityInCart: productCellDelegate.quantityOf(product: product))
        return cell
    }
}

private extension ProductsDataSource {
    func reorderProducts() {
        guard products.count > 1 else { return }
        var prods = products
        if let featuredProduct = prods.max(by: { $0.rating.rate * $0.rating.count < $1.rating.rate * $1.rating.count }),
            let index = prods.firstIndex(of: featuredProduct) {
            let featuredProduct = prods.remove(at: index)
            prods.insert(featuredProduct, at: 0)
        }
        self.products = prods
    }
}
