//
//  OnboardingPage.swift
//  Tracker
//
//  Created by Михаил  on 18.05.2024.
//

import UIKit

final class OnboardingPage: UIViewController{
    private var imageView = UIImageView()
    private var messageLabel = UILabel()
    private var actionButton = UIButton()
    
    init(image: UIImage, messageLabel: String) {
        super.init(nibName: nil, bundle: nil)
        setupUI(image: image, message: messageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(image: UIImage, message: String){
        //Настройка backgroundImage
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        //Настройка лейбла
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .white
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        //Настройка button
//        actionButton.setTitle("Вот это технологии!", for: .normal)
//        actionButton.backgroundColor = .black
//        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        actionButton.layer.cornerRadius = 20
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
//            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
//            actionButton.heightAnchor.constraint(equalToConstant: 40),
//            actionButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
    }
}
