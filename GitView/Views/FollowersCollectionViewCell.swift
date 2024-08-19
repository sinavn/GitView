//
//  FollowersCollectionViewCell.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/29/1403 AP.
//

import UIKit

class FollowersCollectionViewCell: UICollectionViewCell {
    static let identifier = "FollowersCollectionViewCell"
    
    let follower : Follower? = nil
    
    let userLabel = GitTitleLabel(textAlignment: .center, fontSize: 16)
    
    let imageView = GitImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(userLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureConstraints(){
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            userLabel.bottomAnchor.constraint(equalTo: bottomAnchor ),
            userLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    func configureUser(follower:Follower){
        userLabel.text = follower.login
    }
}
