//
//  ProductsDataSource.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class ProductsDataSource: NSObject, UICollectionViewDataSource {
    var featuredProduct: Product?
    
    var products: [Product]
    
    required init(products: [Product]) {
        self.products = products
        super.init()
        getFeaturedProduct()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.setProduct(products[indexPath.row])
        return cell
    }
}

private extension ProductsDataSource {
    func getFeaturedProduct() {
        var prods = products
        featuredProduct = prods.removeFirst()
        self.products = prods
    }
}
