//
//  ProductCell.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProductCell {
    enum Constants {
        static let padding: CGFloat = 8.0
    }
    
    func configureView() {
        self.contentView.addSubview(title)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
}

extension ProductCell {
    func setProduct(_ product: Product) {
        title.text = product.title
    }
}
