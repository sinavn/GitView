//
//  UserInfoViewController.swift
//  GitView
//
//  Created by Sina Vosough Nia on 6/15/1403 AP.
//

import UIKit
import WebKit

class UserInfoViewController: UIViewController {
    
    private var user : User?
    private let avatar = GitImageView(frame: .zero)
    private let userTitle = GitTitleLabel(textAlignment: .left, fontSize: 32)
    private let userbio = GitBodyLabel(textAlignment: .left)
    private let readmeView = ReadmeWebView(frame: .zero, configuration: WKWebViewConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        view.addSubview(userTitle)
        view.addSubview(avatar)
        view.addSubview(userbio)
        view.addSubview(readmeView)
        userbio.numberOfLines = 0
        readmeView.heightConstraint = readmeView.heightAnchor.constraint(equalToConstant: 0)
        
        configureConstraints()

    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 100),
            avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor),
            
            userTitle.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20),
            userTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            userbio.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            userbio.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 20),
            userbio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            readmeView.topAnchor.constraint(equalTo: userbio.bottomAnchor, constant: 20),
            readmeView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            readmeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readmeView.heightAnchor.constraint(equalToConstant: 300)
//            readmeView.heightConstraint
        ])
    }
    
    private func configureVC(){
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    }
    public func getUserInfo(userName:String){
        showLoadingView()
        Task{
            do {
                let fetchedUser = try await NetworkManager.shared.getUserInfo(userName:userName)
                await self.readmeView.getUserReadme(userName: fetchedUser.login)
                self.user = fetchedUser
                self.userTitle.text = fetchedUser.login
                self.userbio.text = fetchedUser.bio
                dismissLoadingView()
            } catch let error {
                print(error)
            }
            await avatar.downloadImage(urlString: user?.avatarUrl ?? "empty")
        }
    }
    
     @objc private func dismissVC (){
        self.dismiss(animated: true)
    }
}
