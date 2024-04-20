//
//  FeaturedProductCell.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

final class FeaturedProductCell: UICollectionViewCell {
    static let identifier = "FeaturedProductCell"
    var product: Product?
    var delegate: ProductCellDelegate?
    
    lazy var selectionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectProduct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(increase), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuantityLabel), name: .cartDidUpdate, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension FeaturedProductCell {
    enum Constants {
        static let verticalPadding: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 18.0
    }
    
    func configureView() {
        self.contentView.addSubview(selectionButton)
        self.contentView.addSubview(image)
        self.contentView.addSubview(title)
        self.contentView.addSubview(price)
        self.contentView.addSubview(minusButton)
        self.contentView.addSubview(quantityLabel)
        self.contentView.addSubview(plusButton)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            selectionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
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
            price.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor),
            
            minusButton.topAnchor.constraint(equalTo: price.topAnchor),
            
            quantityLabel.topAnchor.constraint(equalTo: price.topAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: Constants.horizontalPadding),
            quantityLabel.widthAnchor.constraint(equalToConstant: 20),
            
            plusButton.topAnchor.constraint(equalTo: price.topAnchor),
            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: Constants.horizontalPadding),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalPadding),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor)
        ])
    }
    
    @objc func selectProduct() {
        delegate?.select(product: product)
    }
    
    @objc func decrease() {
        delegate?.decrease(product: product)
    }
    
    @objc func increase() {
        delegate?.increase(product: product, animatedImage: image)
    }
    
    @objc func updateQuantityLabel() {
        guard let product else { return }
        let quantity = delegate?.quantityOf(product: product) ?? 0
        minusButton.isHidden = quantity <= 0
        quantityLabel.isHidden = quantity <= 0
        quantityLabel.text = "\(quantity)"
    }
}

extension FeaturedProductCell {
    func setProduct(_ product: Product, quantityInCart: Int) {
        self.product = product
        title.text = product.title
        minusButton.isHidden = quantityInCart <= 0
        quantityLabel.isHidden = quantityInCart <= 0
        quantityLabel.text = "\(quantityInCart)"
        price.text = "\(product.price)"
        delegate?.downloadImage(product: product, imageView: image)
    }
}
