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
        navigationController?.isNavigationBarHidden = true
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
    
//    private func presentAlert(){
////        let alert = UIAlertController(title: "", message: "the entered username is not valid", preferredStyle: .alert)
////        let action = UIAlertAction(title: "ok", style: .default)
////        alert.addAction(action)
//        DispatchQueue.main.async {
//            let vc = GitAlertVC(alertTitle: "empty username", massage: "the entered username is not valid", buttonTitle: "OK")
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true)
//        }
//       
//    }
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
            self.searchTextField.transform = isKeyboardShowing ? .init(translationX: 0, y: -30) : .identity
        }
    }
    
}

extension SearchVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        pushToFollowersListVC()
        return true
    }
}
