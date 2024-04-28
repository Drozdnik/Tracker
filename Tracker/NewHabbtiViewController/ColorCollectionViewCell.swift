//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Михаил  on 10.04.2024.
//

import Foundation
import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clear.cgColor
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
        contentView.addSubview(borderView)
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            borderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            borderView.heightAnchor.constraint(equalTo: colorView.heightAnchor, constant: 10), // Adjust size as needed
            borderView.widthAnchor.constraint(equalTo: colorView.widthAnchor, constant: 10),
            
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func setSelectedState(with borderColor: UIColor) {
        borderView.layer.borderColor = borderColor.cgColor
        borderView.backgroundColor = UIColor.white.withAlphaComponent(0.5) 
    }
    
    func setDeselectedState() {
        borderView.layer.borderColor = UIColor.clear.cgColor
        borderView.backgroundColor = .clear
    }
}
