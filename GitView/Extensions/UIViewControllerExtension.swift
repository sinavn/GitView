//
//  UIViewControllerExtension.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/25/1403 AP.
//

import UIKit

fileprivate var containerView : UIView!

extension UIViewController {
    func presentGitAlertOnMainThread(title:String , massage : String , buttonTitle:String){
        DispatchQueue.main.async {
            let vc = GitAlertVC(alertTitle: title, massage: massage, buttonTitle: buttonTitle)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.85
        }
        
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView (){
        containerView.removeFromSuperview()
        containerView = nil
    }
    
    func showEmptyStateView(message : String , view : UIView){
        let emptyStateView = EmptyStateView(message: message)
        view.addSubview(emptyStateView)
        emptyStateView.frame = view.bounds

    }
}
