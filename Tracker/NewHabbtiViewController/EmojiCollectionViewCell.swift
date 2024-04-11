//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Михаил  on 10.04.2024.
//

import Foundation
import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    let emojiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 38),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 32)
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
}
