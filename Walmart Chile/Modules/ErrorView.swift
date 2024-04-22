//
//  ErrorView.swift
//  Walmart Chile
//
//  Created by Samuel García on 22-04-24.
//

import UIKit

final class ErrorView: UIView {
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    lazy var errorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "ErrorLoadingImage")
        return image
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Error")
        label.textAlignment = .center
        return label
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Retry"), for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        return button
    }()
    
    var error: NetworkError? {
        didSet {
            errorMessageLabel.text = error?.errorDescription
        }
    }
    
    var retry: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ErrorView {
    enum Constants {
        static let margins: CGFloat = 40.0
        static let spacing: CGFloat = 10.0
        static let imageSize: CGFloat = 180.0
        static let cornerRadius: CGFloat = 8.0
    }
    
    func configureView() {
        addSubview(containerView)
        containerView.addSubview(errorImage)
        containerView.addSubview(errorLabel)
        containerView.addSubview(errorMessageLabel)
        containerView.addSubview(retryButton)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.margins),
            errorImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.margins),
            errorImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.margins),
            errorImage.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            errorImage.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            
            errorLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: Constants.spacing),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            errorMessageLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Constants.spacing),
            errorMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.margins),
            errorMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.margins),
            errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: Constants.spacing),
            retryButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.margins),
            retryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.margins),
            retryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.margins),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc func retryAction() {
        retry?()
    }
}
