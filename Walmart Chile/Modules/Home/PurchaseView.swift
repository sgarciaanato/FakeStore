//
//  PurchaseView.swift
//  Walmart Chile
//
//  Created by Samuel García on 21-04-24.
//

import UIKit

final class PurchaseView: UIView {
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    lazy var successImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "CartSuccess")
        return image
    }()
    
    lazy var successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Success")
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PurchaseView {
    enum Constants {
        static let margins: CGFloat = 40.0
        static let spacing: CGFloat = 10.0
        static let imageSize: CGFloat = 80.0
        static let cornerRadius: CGFloat = 8.0
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.addSubview(successImage)
        containerView.addSubview(successLabel)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            successImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.margins),
            successImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.margins),
            successImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.margins),
            successImage.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            successImage.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            
            successLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: Constants.spacing),
            successLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.margins),
            successLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
