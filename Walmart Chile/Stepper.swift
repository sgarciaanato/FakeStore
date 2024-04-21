//
//  Stepper.swift
//  Walmart Chile
//
//  Created by Samuel García on 21-04-24.
//

import UIKit

protocol StepperDelegate {
    func increase()
    func decrease()
}

final class Stepper: UIStackView {
    var delegate: StepperDelegate?
    var product: Product?
    var quantity: Int {
        didSet {
            quantityLabel.text = "\(quantity)"
            if quantity > 0, !minusButton.isHidden { return }
            if quantity == 0, minusButton.isHidden { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                minusButton.isHidden = quantity == 0
                quantityLabel.isHidden = quantity == 0
                minusButton.alpha = quantity == 0 ? 0.0 : 1.0
                quantityLabel.alpha = quantity == 0 ? 0.0 : 1.0
            }
        }
    }
    
    lazy var minusButton: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "minus.circle")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(decrease))
        tapGesture.numberOfTapsRequired = 1
        image.addGestureRecognizer(tapGesture)
        return image
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var plusButton: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "plus.circle")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(increase))
        tapGesture.numberOfTapsRequired = 1
        image.addGestureRecognizer(tapGesture)
        return image
    }()
    
    init() {
        product = nil
        quantity = 0
        super.init(frame: .zero)
        configureSubViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Stepper {
    enum Constants {
        static let innerButtonsMargins: CGFloat = 2.0
        static let buttonSize: CGFloat = 30.0
        static let labelWidth: CGFloat = 30.0
    }
    
    func configureSubViews() {
        addArrangedSubview(minusButton)
        addArrangedSubview(quantityLabel)
        addArrangedSubview(plusButton)
        configureConstraints()
        backgroundColor = .systemBackground
        layer.cornerRadius = (Constants.buttonSize / 2)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            minusButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            minusButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            
            quantityLabel.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            
            plusButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            plusButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
        ])
    }
    
    @objc func increase() {
        delegate?.increase()
    }
    
    @objc func decrease() {
        delegate?.decrease()
    }
}
