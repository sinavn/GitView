//
//  GitImageView.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/29/1403 AP.
//

import UIKit

class GitImageView: UIImageView {
    
    let placeHolderImage = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        image = placeHolderImage
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
}
