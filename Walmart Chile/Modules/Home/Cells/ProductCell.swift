//
//  ProductCell.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        image.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return image
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    lazy var addToCart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        return button
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
        static let verticalPadding: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 18.0
    }
    
    func configureView() {
        self.contentView.addSubview(image)
        self.contentView.addSubview(title)
        self.contentView.addSubview(price)
        self.contentView.addSubview(addToCart)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            image.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Constants.verticalPadding),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            price.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constants.verticalPadding),
            price.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            addToCart.topAnchor.constraint(equalTo: price.topAnchor),
            addToCart.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: Constants.horizontalPadding),
            addToCart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            addToCart.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            addToCart.widthAnchor.constraint(equalTo: addToCart.heightAnchor)
        ])
    }
}

extension ProductCell {
    func setProduct(_ product: Product, networkManager: NetworkManager) {
        title.text = product.title
        price.text = "\(product.price)"
        networkManager.getImage(from: product.image) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.image.image = UIImage(data: data)
                }
            case .failure(let error):
                // TODO: show error
                debugPrint(error)
            }
        }
    }
}
