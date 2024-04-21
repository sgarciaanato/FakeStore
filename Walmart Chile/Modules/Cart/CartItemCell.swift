//
//  CartItemCell.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol CartItemCellDelegate {
    func increase(product: Product?, animatedImage: UIImageView)
    func remove(product: Product?)
    func decrease(product: Product?)
    func select(product: Product?)
    func quantityOf(product: Product?) -> Int
    func downloadImage(product: Product?, imageView: UIImageView)
}

final class CartItemCell: UICollectionViewCell {
    static let identifier = "FeaturedProductCell"
    var cartItem: CartItem?
    var delegate: CartItemCellDelegate?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .secondarySystemBackground
        view.center = self.contentView.center
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSizeMake(3, 3)
        view.layer.shadowRadius = 1
        return view
    }()
    
    lazy var selectionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectProduct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        image.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(remove), for: .touchUpInside)
        button.setTitle("Quitar", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 6
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = Constants.buttonInsets
        button.configuration = configuration
        return button
    }()
    
    lazy var stepper: Stepper = {
        let stepper = Stepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.delegate = self
        return stepper
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

private extension CartItemCell {
    enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let outerMargins: CGFloat = 4.0
        static let innerMargins: CGFloat = 6.0
        static let innerImageMargins: CGFloat = 24.0
        static let innerButtonsMargins: CGFloat = 2.0
        static let quantityContainerHeight: CGFloat = 26.0
        static let quantityContainerWidth: CGFloat = 76.0
        static let buttonInsets: NSDirectionalEdgeInsets = .init(top: 4.0, leading: 16.0, bottom: 4.0, trailing: 16.0)
    }
    
    func configureView() {
        contentView.addSubview(containerView)
        containerView.addSubview(selectionButton)
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(removeButton)
        containerView.addSubview(stepper)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.outerMargins),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.outerMargins),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.outerMargins),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.outerMargins),
            
            selectionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageContainerView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            imageContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerMargins),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: Constants.innerImageMargins),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: imageContainerView.leadingAnchor, constant: Constants.innerImageMargins),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -Constants.innerImageMargins),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: imageContainerView.bottomAnchor, constant: -Constants.innerImageMargins),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: Constants.innerMargins),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerMargins),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.innerMargins),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerMargins),
            
            removeButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.innerMargins),
            removeButton.centerXAnchor.constraint(equalTo: priceLabel.centerXAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerMargins),
            stepper.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.innerMargins)
        ])
        
    }
    
    @objc func selectProduct() {
        guard let product = cartItem?.product else { return }
        delegate?.select(product: product)
    }
    
    @objc func remove() {
        guard let product = cartItem?.product else { return }
        delegate?.remove(product: product)
    }
    
    @objc func updateQuantityLabel() {
        guard let product = cartItem?.product else { return }
        stepper.quantity = delegate?.quantityOf(product: product) ?? 0
    }
}

extension CartItemCell {
    func setCartItem(_ cartItem: CartItem) {
        self.cartItem = cartItem
        titleLabel.text = cartItem.product.title
        stepper.quantity = cartItem.quantity
        priceLabel.text = "$\(cartItem.product.price)"
        delegate?.downloadImage(product: cartItem.product, imageView: imageView)
    }
}

extension CartItemCell: StepperDelegate {
    func increase() {
        guard let product = cartItem?.product else { return }
        delegate?.increase(product: product, animatedImage: imageView)
    }
    
    func decrease() {
        guard let product = cartItem?.product else { return }
        delegate?.decrease(product: product)
    }
}
