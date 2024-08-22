//
//  GitImageView.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/29/1403 AP.
//

import UIKit

class GitImageView: UIImageView {
    
    let placeHolderImage = UIImage(named: "avatar-placeholder")
    let cache = NetworkManager.shared.cache
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
    
    func downloadImage (urlString : String) async {
        
        let objectKey  = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: objectKey){
            image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        do {
            let (data , _ ) = try await URLSession.shared.data(from: url)
            let avatarImage = UIImage(data: data)
            image = avatarImage
            if let safeAvatar = avatarImage {
                cache.setObject(safeAvatar, forKey: objectKey)
            }
        } catch {
        }
    }
}
