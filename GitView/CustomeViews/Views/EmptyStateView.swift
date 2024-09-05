//
//  EmptyStateView.swift
//  GitView
//
//  Created by Sina Vosough Nia on 6/12/1403 AP.
//

import UIKit

class EmptyStateView: UIView {

    let messageLabel = GitTitleLabel(textAlignment: .center, fontSize: 28)
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (message:String){
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    private func configure (){
        addSubview(messageLabel)
        addSubview(imageView)
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        imageView.image = UIImage(named: "empty-state-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor , constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
            
        ])
    }
}
