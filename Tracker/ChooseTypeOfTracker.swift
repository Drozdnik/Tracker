//
//  ChooseTypeOfTracker.swift
//  Tracker
//
//  Created by Михаил  on 09.04.2024.
//

import Foundation
import UIKit

final class ChooseTypeOfTracker: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews([buttonContrainer])
        configureConstraints()
        configureNavBar()
    }
    
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            buttonContrainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonContrainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
  private   func configureNavBar(){
        let title = "Создание трекера"
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    private lazy var buttonContrainer: UIView = {
        let container = UIView ()
        
        let firstButton = UIButton()
        firstButton.setTitle("Привычка", for: .normal)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.backgroundColor = UIColor(named: "TotalBlack")
        firstButton.layer.cornerRadius = 16
        firstButton.layer.masksToBounds = true
        firstButton.addTarget(self, action: #selector(habbitButtonTapped), for: .touchUpInside)
        
        let secondButton = UIButton()
        secondButton.setTitle("Нерегулярное событие", for: .normal)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.backgroundColor = UIColor(named: "TotalBlack")
        secondButton.layer.cornerRadius = 16
        secondButton.layer.masksToBounds = true
        
        container.addSubviews([firstButton, secondButton])
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstButton.topAnchor.constraint(equalTo: container.topAnchor),
            firstButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            firstButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            firstButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            firstButton.widthAnchor.constraint(equalToConstant: 335),
            firstButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 16),
            secondButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            secondButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            secondButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            secondButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            secondButton.widthAnchor.constraint(equalToConstant: 335),
            secondButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return container
    }()
    
    @objc private func habbitButtonTapped(){
        let vc = NewHabbitViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
}
