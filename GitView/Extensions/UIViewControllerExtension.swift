//
//  UIViewControllerExtension.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/25/1403 AP.
//

import UIKit

extension UIViewController {
    func presentGitAlertOnMainThread(title:String , massage : String , buttonTitle:String){
        DispatchQueue.main.async {
            let vc = GitAlertVC(alertTitle: title, massage: massage, buttonTitle: buttonTitle)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
}
