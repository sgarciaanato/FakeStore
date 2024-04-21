//
//  ProductDetailViewController.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol ProductDetailViewControllerDelegate {
    func reloadView(with product: Product, quantityInCart: Int)
}

final class ProductDetailViewController: UIViewController {
    let presenter: ProductDetailPresenterDelegate
    var quantityContainerHidden: NSLayoutConstraint?
    var quantityContainerShown: NSLayoutConstraint?
    
    var showQuantity: Bool {
        didSet {
            quantityContainerShown?.priority = showQuantity ? UILayoutPriority(999) : UILayoutPriority(1)
            quantityContainerHidden?.priority = showQuantity ? UILayoutPriority(1) : UILayoutPriority(999)
            if !showQuantity {
                minusButton.alpha = 0.0
                quantityLabel.alpha = 0.0
            }
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self else { return }
                minusButton.alpha = showQuantity ? 1.0 : 0.0
                quantityLabel.alpha = showQuantity ? 1.0 : 0.0
            }
        }
    }
    
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
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = UIFont.boldSystemFont(ofSize: 26.0)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textAlignment = .right
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    lazy var startImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .label
        return image
    }()
    
    lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var quantityContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    required init(presenter: ProductDetailPresenterDelegate) {
        self.presenter = presenter
        showQuantity = true
        super.init(nibName: nil, bundle: nil)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
    }
}

private extension ProductDetailViewController {
    enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let verticalPadding: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 18.0
        static let innerMargins: CGFloat = 6.0
        static let innerImageMargins: CGFloat = 24.0
        static let innerButtonsMargins: CGFloat = 2.0
        static let quantityContainerHeight: CGFloat = 26.0
        static let quantityContainerWidth: CGFloat = 76.0
    }
    
    func configureView() {
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(ratingContainerView)
        ratingContainerView.addSubview(startImageView)
        ratingContainerView.addSubview(rateLabel)
        view.addSubview(quantityContainerView)
        quantityContainerView.addSubview(minusButton)
        quantityContainerView.addSubview(quantityLabel)
        quantityContainerView.addSubview(plusButton)
        configureConstraints()
    }
    
    func configureConstraints() {
        let quantityContainerHidden = quantityContainerView.leadingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -Constants.quantityContainerHeight)
        quantityContainerHidden.priority = UILayoutPriority(1)
        
        let quantityContainerShown = quantityContainerView.leadingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -Constants.quantityContainerWidth)
        self.quantityContainerHidden = quantityContainerHidden
        self.quantityContainerShown = quantityContainerShown
        
        NSLayoutConstraint.activate([
            
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.horizontalPadding),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: Constants.innerImageMargins),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: imageContainerView.leadingAnchor, constant: Constants.innerImageMargins),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -Constants.innerImageMargins),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: imageContainerView.bottomAnchor, constant: -Constants.innerImageMargins),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: Constants.innerMargins),
            titleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.innerMargins),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.horizontalPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: ratingContainerView.topAnchor, constant: -Constants.innerMargins),
            
            ratingContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.innerMargins),
            
            startImageView.topAnchor.constraint(equalTo: ratingContainerView.topAnchor, constant: Constants.innerButtonsMargins),
            startImageView.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor, constant: Constants.innerButtonsMargins),
            startImageView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: -Constants.innerButtonsMargins),
            
            rateLabel.topAnchor.constraint(equalTo: ratingContainerView.topAnchor, constant: Constants.innerButtonsMargins),
            rateLabel.leadingAnchor.constraint(equalTo: startImageView.trailingAnchor, constant: Constants.innerButtonsMargins),
            rateLabel.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor, constant: -Constants.innerButtonsMargins),
            rateLabel.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: -Constants.innerButtonsMargins),
            
            quantityContainerView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -Constants.innerMargins),
            quantityContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.innerMargins),
            quantityContainerView.heightAnchor.constraint(equalToConstant: Constants.quantityContainerHeight),
            quantityContainerHidden,
            quantityContainerShown,
            
            minusButton.topAnchor.constraint(equalTo: quantityContainerView.topAnchor, constant: Constants.innerButtonsMargins),
            minusButton.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: Constants.innerButtonsMargins),
            minusButton.bottomAnchor.constraint(equalTo: quantityContainerView.bottomAnchor, constant: -Constants.innerButtonsMargins),
            
            quantityLabel.topAnchor.constraint(equalTo: quantityContainerView.topAnchor, constant: Constants.innerButtonsMargins),
            quantityLabel.centerXAnchor.constraint(equalTo: quantityContainerView.centerXAnchor, constant: Constants.innerButtonsMargins),
            quantityLabel.bottomAnchor.constraint(equalTo: quantityContainerView.bottomAnchor, constant: -Constants.innerButtonsMargins),
            
            plusButton.topAnchor.constraint(equalTo: quantityContainerView.topAnchor, constant: Constants.innerButtonsMargins),
            plusButton.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -Constants.innerButtonsMargins),
            plusButton.bottomAnchor.constraint(equalTo: quantityContainerView.bottomAnchor, constant: -Constants.innerButtonsMargins)
        ])
    }
    
    @objc func decrease() {
        presenter.decrease()
    }
    
    @objc func increase() {
        presenter.increase()
    }
}

extension ProductDetailViewController: ProductDetailViewControllerDelegate {
    func reloadView(with product: Product, quantityInCart: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.titleLabel.text = product.title
            showQuantity = quantityInCart > 0
            self.quantityLabel.text = "\(quantityInCart)"
            self.priceLabel.text = "\(product.price)"
            self.descriptionLabel.text = product.description
            self.rateLabel.text = "\(product.rating.rate) (\(product.rating.count))"
        }
        presenter.downloadImage(product: product, imageView: imageView)
    }
}
