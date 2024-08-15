//
//  GitAlertVC.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/25/1403 AP.
//

import UIKit

class GitAlertVC: UIViewController {

    let containerView = UIView()
    let titleLabel = GitTitleLabel(textAlignment: .center, fontSize: 28)
    let massageLabel = GitBodyLabel(textAlignment: .center)
    let alertButton = GitButton(backgroundColor: .systemPink, title: "OK")
    
    var alertTitle : String?
    var massage : String?
    var buttonTitle : String?
    
    let padding : CGFloat = 20
    init(alertTitle : String , massage : String , buttonTitle:String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.massage = massage
        self.buttonTitle = buttonTitle
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        configureTitleLabel()
        configureAlertButton()
        configureAlertMassage()
    }
    
    private func configureContainerView(){
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let bluredEffectView = UIVisualEffectView(effect: blurEffect)
        bluredEffectView.frame = view.bounds
        view.addSubview(bluredEffectView)
        view.addSubview(containerView)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func configureTitleLabel(){
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    private func configureAlertButton(){
        containerView.addSubview(alertButton)
        alertButton.setTitle(buttonTitle ?? "OK", for: .normal)
        alertButton.addTarget(self, action: #selector(dissmisVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            alertButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            alertButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func configureAlertMassage(){
        containerView.addSubview(massageLabel)
        massageLabel.text = massage ?? "Unable to complete request"
        massageLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            massageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            massageLabel.bottomAnchor.constraint(equalTo: alertButton.topAnchor, constant: -8),
            massageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor , constant: padding),
            massageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor , constant: -padding)
        ])
    }
    
    @objc private func dissmisVC(){
        self.dismiss(animated: true)
    }
}
