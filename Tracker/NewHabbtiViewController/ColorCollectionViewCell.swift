//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Михаил  on 10.04.2024.
//

import Foundation
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // Можно добавить дополнительные UI элементы, если нужно
        contentView.backgroundColor = .clear // Потом здесь будет настоящий цвет
    }
    
    func configure(with color: UIColor) {
        contentView.backgroundColor = color
    }
}
