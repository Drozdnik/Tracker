//
//  NavigationBarCustom.swift
//  Tracker
//
//  Created by Михаил  on 06.04.2024.
//

import Foundation
import UIKit

final class NavigationBarCustom: UIView{
    let titleLabel = UILabel()
    let dataButton = UIButton()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
           configureConstraints()
       }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        configureConstraints()
    }
    
    private func setupViews(){
        addSubviews([titleLabel, searchTextField, addButton, dateButton])
        configureTitleLabel()
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  6),
            
            dateButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func configureTitleLabel(){
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton.systemButton(
            with: UIImage(systemName: "plus")!,
            target: self,
            action: #selector(didTapAddButton)
        )
        addButton.tintColor = .black
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
    @objc private func didTapAddButton(){
        
    }
    
    private lazy var dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("14.12.22", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "GrayForNavBar")
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Поиск"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor(named: "GrayForNavBar")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
}
