//
//  UIHelper.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/30/1403 AP.
//

import UIKit

struct UIHelper {
    
    static func configureCollectionFlowLayout (view:UIView)-> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding : CGFloat = 16
        let itemSpacing : CGFloat = 10
        let itemWidth = (width - (padding * 2 ) - (itemSpacing * 2 )) / 3

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset =  UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 30)
        return layout
    }
}
