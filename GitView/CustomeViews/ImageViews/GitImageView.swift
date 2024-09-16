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
    let activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(activityIndicator)
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func downloadImage (urlString : String) async {
        image = placeHolderImage
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        let objectKey  = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: objectKey){
            DispatchQueue.main.async {
                self.image = cachedImage
                self.activityIndicator.stopAnimating()
            }
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        do {
            let (data , _ ) = try await URLSession.shared.data(from: url)
            let avatarImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = avatarImage
                self.activityIndicator.stopAnimating()
            }
          
            if let safeAvatar = avatarImage {
                cache.setObject(safeAvatar, forKey: objectKey)
            }
        } catch {
            DispatchQueue.main.async {
                self.image = self.placeHolderImage
                self.activityIndicator.stopAnimating()

            }
        }
    }
}
