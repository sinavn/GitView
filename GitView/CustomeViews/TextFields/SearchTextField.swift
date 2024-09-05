//
//  SearchTextField.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/23/1403 AP.
//

import UIKit

class SearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        translatesAutoresizingMaskIntoConstraints = false
        placeholder = "Enter a username"
        returnKeyType = .search
    
    }
}
