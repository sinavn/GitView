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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        Task{
            do{
                let result = try await NetworkManager.shared.getFollowers(for: username, page: 1)
                print(result.count)
            }catch let error as NetworkManager.NetworkError{
                presentGitAlertOnMainThread(title: "Oops!", massage: error.localizedDescription, buttonTitle: "OK")
                print(error.localizedDescription)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
