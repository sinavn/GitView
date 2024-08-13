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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogo()
        configureSubviews()
        configureConstraints()
        configureKeyboardObservers()
    }
    private func configureLogo (){
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "gh-logo")
//        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func configureSubviews(){
        view.addSubview(searchTextField)
        view.addSubview(gitActionButton)
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            gitActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        UIView.animate(withDuration: 0.3) {
            self.gitActionButton.transform = isKeyboardShowing ? .init(translationX: 0, y: -keyboardHeight + self.view.safeAreaInsets.bottom + 20) : .identity
        }
    }
    
}
//self.searchTextField.transform = isKeyboardShowing ? .init(translationX: 0, y: -self.gitActionButton.layer.position.y - keyboardHeight) : .identity
