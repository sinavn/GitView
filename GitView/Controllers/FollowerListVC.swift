//
//  FollowerListVC.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/24/1403 AP.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String = ""

        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
