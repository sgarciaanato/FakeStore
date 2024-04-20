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
    
    required init(products: [Product], delegate: ProductCellDelegate) {
        self.products = products
        self.productCellDelegate = delegate
        super.init()
        reorderProducts()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return products.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.delegate = productCellDelegate
        var product = products[0]
        if indexPath.section != 0 {
            product = products[indexPath.row + 1]
        }
        cell.setProduct(product, quantityInCart: productCellDelegate.quantityOf(product: product))
        return cell
    }
}

private extension ProductsDataSource {
    func reorderProducts() {
        var prods = products
        let featuredProduct = prods.removeFirst()
        prods.insert(featuredProduct, at: 0)
        self.products = prods
    }
}
