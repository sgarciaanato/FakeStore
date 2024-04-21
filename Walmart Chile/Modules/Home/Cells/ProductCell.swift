//
//  ProductCell.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

protocol ProductCellDelegate {
    var isLoading: Bool { get }
    var products: [Product] { get }
    func increase(product: Product?, animatedImage: UIImageView)
    func decrease(product: Product?)
    func select(product: Product?)
    func quantityOf(product: Product?) -> Int
    func downloadImage(product: Product?, imageView: UIImageView)
}

final class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    var product: Product?
    var delegate: ProductCellDelegate?
    var quantityContainerHidden: NSLayoutConstraint?
    var quantityContainerShown: NSLayoutConstraint?
    
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
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

private extension ProductCell {
    enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let outerMargins: CGFloat = 4.0
        static let innerMargins: CGFloat = 6.0
        static let innerImageMargins: CGFloat = 24.0
        static let innerButtonsMargins: CGFloat = 2.0
        static let quantityContainerHeight: CGFloat = 26.0
        static let quantityContainerWidth: CGFloat = 76.0
    }
    
    func configureView() {
        contentView.addSubview(containerView)
        containerView.addSubview(selectionButton)
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
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
            
            imageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.innerMargins),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerMargins),
            imageContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerMargins),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: Constants.innerImageMargins),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: imageContainerView.leadingAnchor, constant: Constants.innerImageMargins),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -Constants.innerImageMargins),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: imageContainerView.bottomAnchor, constant: -Constants.innerImageMargins),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: Constants.innerMargins),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.innerMargins),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerMargins),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.innerMargins),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -Constants.innerMargins),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.innerMargins),
            
            stepper.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.innerMargins),
            stepper.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.innerMargins),
            stepper.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.innerMargins)
        ])
    }
    
    @objc func selectProduct() {
        delegate?.select(product: product)
    }
    
    @objc func updateQuantityLabel() {
        guard let product else { return }
        stepper.quantity = delegate?.quantityOf(product: product) ?? 0
    }
}

extension ProductCell {
    func setProduct(_ product: Product, quantityInCart: Int) {
        self.product = product
        titleLabel.text = product.title
        stepper.quantity = quantityInCart
        priceLabel.text = "$\(product.price)"
        delegate?.downloadImage(product: product, imageView: imageView)
    }
}

extension ProductCell: StepperDelegate {
    func increase() {
        delegate?.increase(product: product, animatedImage: imageView)
    }
    
    func decrease() {
        delegate?.decrease(product: product)
    }
}
