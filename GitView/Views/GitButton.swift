//
//  GitButton.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/23/1403 AP.
//

import UIKit

class GitButton: UIButton {
//
    override init(frame: CGRect) {
        super.init(frame: frame)
            configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor:UIColor , title:String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        configure()
    }
    
    private func configure (){
        layer.cornerRadius = 10
        titleLabel?.textColor = .label
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
