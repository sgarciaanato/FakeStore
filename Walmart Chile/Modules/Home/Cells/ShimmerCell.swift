//
//  ShimmerCell.swift
//  Walmart Chile
//
//  Created by Samuel García on 21-04-24.
//

import UIKit

class ShimmerCell: UICollectionViewCell {
    static let identifier = "ShimmerCell"
    lazy var shimmerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        
        view.layer.addSublayer(gradient)
        
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradient.add(animationGroup, forKey: "backgroundColor")
        
        return view
    }()
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            gradient.frame = shimmerView.bounds
        }
    }
}

private extension ShimmerCell {
    enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let margins: CGFloat = 4.0
    }
    
    func configureView() {
        contentView.addSubview(shimmerView)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margins),
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margins),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margins),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margins)
        ])
    }
    
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1.5
        
        let anim1 = CABasicAnimation( keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.lightGray.cgColor
        anim1.toValue = UIColor.secondarySystemBackground.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0
        
        let anim2 = CABasicAnimation( keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.secondarySystemBackground.cgColor
        anim2.toValue = UIColor.lightGray.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + animDuration
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false
        
        if let previousGroup {
            group.beginTime = previousGroup.beginTime + 0.3
        }
        
        return group
    }
}
