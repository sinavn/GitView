//
//  SearchVC.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/22/1403 AP.
//

import UIKit

class SearchVC: UIViewController {

    let logoImageView = UIImageView()
    let searchTextField = SearchTextField()
    let gitActionButton = GitButton(backgroundColor: .systemGreen, title: "Search username")
    var gitActionButtonBottomConstraint : NSLayoutConstraint?
    var searchTextFieldtopConstraints : NSLayoutConstraint?
    var searchTextFieldBottomConstraints : NSLayoutConstraint?
    var isEnteredUsernameValid : Bool {
        !searchTextField.text!.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchTextField.delegate = self
        configureLogo()
        configureSubviews()
        configureConstraints()
        configureKeyboardObservers()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func pushToFollowersListVC (){
        guard isEnteredUsernameValid else {
            presentGitAlertOnMainThread(title: "Username is empty", massage: "we need some username to search for 😔", buttonTitle: "OK")
            return }
        searchTextField.endEditing(true)
        let vc = FollowerListVC()
        
        vc.title = searchTextField.text!
        vc.username = searchTextField.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    

    private func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func configureLogo (){
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "gh-logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSubviews(){
        view.addSubview(searchTextField)
        view.addSubview(gitActionButton)
        gitActionButton.addTarget(self, action: #selector(pushToFollowersListVC), for: .touchUpInside)
    }
    
    private func configureConstraints(){

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        searchTextFieldtopConstraints = searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50)
        NSLayoutConstraint.activate([
            searchTextFieldtopConstraints!,
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        gitActionButtonBottomConstraint = gitActionButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -40)

        NSLayoutConstraint.activate([
            gitActionButtonBottomConstraint!,
            gitActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            gitActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            gitActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange) , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWillChange (_ notification:Notification){

        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        gitActionButtonBottomConstraint?.constant = isKeyboardShowing ? -20 : -40
        view.layoutIfNeeded()
        
        let buttonMinY = gitActionButton.frame.minY
        let searchMaxY = searchTextField.frame.maxY

        if isKeyboardShowing && (buttonMinY - 10) < searchMaxY {
            searchTextFieldBottomConstraints = searchTextField.bottomAnchor.constraint(equalTo: gitActionButton.topAnchor, constant: -10)
            searchTextFieldtopConstraints?.isActive = false
            searchTextFieldBottomConstraints?.isActive = true
        } else if !isKeyboardShowing {
            searchTextFieldBottomConstraints?.isActive = false
            searchTextFieldtopConstraints?.isActive = true

        }
        view.layoutIfNeeded()
        
    }
    
}

extension SearchVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        pushToFollowersListVC()
        return true
    }
}
