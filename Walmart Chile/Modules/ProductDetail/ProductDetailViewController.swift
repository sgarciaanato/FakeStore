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
    
    lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        image.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return image
    }()
    
    lazy var productTitle: UILabel = {
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
        self.view.backgroundColor = .systemBackground
    }
}

private extension ProductDetailViewController {
    enum Constants {
        static let verticalPadding: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 18.0
    }
    
    func configureView() {
        self.view.addSubview(productImage)
        self.view.addSubview(productTitle)
        self.view.addSubview(price)
        self.view.addSubview(minusButton)
        self.view.addSubview(quantityLabel)
        self.view.addSubview(plusButton)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.verticalPadding),
            productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor),
            productImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productImage.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            productImage.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            
            productTitle.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: Constants.verticalPadding),
            productTitle.leadingAnchor.constraint(equalTo: productImage.leadingAnchor, constant: Constants.horizontalPadding),
            productTitle.trailingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: -Constants.horizontalPadding),
            
            price.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: Constants.verticalPadding),
            price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            price.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor),
            
            minusButton.topAnchor.constraint(equalTo: price.topAnchor),
            
            quantityLabel.topAnchor.constraint(equalTo: price.topAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: Constants.horizontalPadding),
            quantityLabel.widthAnchor.constraint(equalToConstant: 20),
            
            plusButton.topAnchor.constraint(equalTo: price.topAnchor),
            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: Constants.horizontalPadding),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.verticalPadding),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor)
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
            self.productTitle.text = product.title
            self.minusButton.isHidden = quantityInCart <= 0
            self.quantityLabel.isHidden = quantityInCart <= 0
            self.quantityLabel.text = "\(quantityInCart)"
            self.price.text = "\(product.price)"
        }
        presenter.downloadImage(product: product, imageView: productImage)
    }
}
