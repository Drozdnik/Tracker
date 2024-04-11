//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Михаил  on 10.04.2024.
//

import Foundation
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(colorView) // Добавить colorView на contentView
        
        // Настроить ограничения для colorView
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color // Установить фоновый цвет colorView
    }
}
