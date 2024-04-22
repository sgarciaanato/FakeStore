//
//  ProductDetailViewController.swift
//  Walmart Chile
//
//  Created by Samuel García on 20-04-24.
//

import UIKit

protocol ProductDetailViewControllerDelegate {
    func reloadView(with product: Product, quantityInCart: Int, isLoading: Bool)
}

final class ProductDetailViewController: UIViewController {
    let presenter: ProductDetailPresenterDelegate
    var quantityContainerHidden: NSLayoutConstraint?
    var quantityContainerShown: NSLayoutConstraint?
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .secondaryLabel
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
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
    
    lazy var stepper: Stepper = {
        let stepper = Stepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.delegate = self
        return stepper
    }()
    
    required init(presenter: ProductDetailPresenterDelegate) {
        self.presenter = presenter
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
        view.addSubview(closeButton)
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(ratingContainerView)
        ratingContainerView.addSubview(startImageView)
        ratingContainerView.addSubview(rateLabel)
        view.addSubview(stepper)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalPadding),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainerView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Constants.horizontalPadding),
            
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: Constants.innerImageMargins),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: imageContainerView.leadingAnchor, constant: Constants.innerImageMargins),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -Constants.innerImageMargins),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: imageContainerView.bottomAnchor, constant: -Constants.innerImageMargins),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: Constants.innerMargins),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.innerMargins),
            
            priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.innerMargins),
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
            
            stepper.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: -Constants.innerMargins),
            stepper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.innerMargins)
        ])
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}

extension ProductDetailViewController: ProductDetailViewControllerDelegate {
    func reloadView(with product: Product, quantityInCart: Int, isLoading: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.titleLabel.text = product.title
            stepper.quantity = quantityInCart
            /// `isLoading is used to mock the difference between the model from list product to the fully loaded product
            self.priceLabel.text = "$\(product.price)"
            self.rateLabel.text = "\(product.rating.rate) (\(product.rating.count))"
            if isLoading { return }
            self.descriptionLabel.text = product.description
        }
        presenter.downloadImage(product: product, imageView: imageView)
    }
}

extension ProductDetailViewController: StepperDelegate {
    func increase() {
        presenter.increase()
    }
    
    func decrease() {
        presenter.decrease()
    }
}
