//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Михаил  on 21.04.2024.
//

import Foundation
import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    // Элементы UI для верхней секции
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let topContainer = UIView()
    
    // Элементы UI для нижней секции
    private let dayLabel = UILabel()
    private let addButton = UIButton()
    private let bottomContainer = UIView()
    static let identifier = "TrackerCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Добавление контейнеров и элементов к contentView
        [topContainer, bottomContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [emojiLabel, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topContainer.addSubview($0)
        }
        
        [dayLabel, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomContainer.addSubview($0)
        }
        
        // Настройка внешнего вида элементов
        topContainer.layer.cornerRadius = 12
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
        addButton.tintColor = .white
        emojiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textAlignment = .left
    }
    
    private func setupConstraints() {
        // Ограничения для topContainer
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
        
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 12), // Изменено
            nameLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12), // Изменено
            nameLabel.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -12), // Неизменно
            
            // Ограничения для bottomContainer
            bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 58),
            
            // Ограничения для dayLabel и addButton в bottomContainer
            dayLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 12),
            dayLabel.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -12),
            addButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureWith(tracker: Tracker) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        dayLabel.text = "\(tracker.schedule)"
        topContainer.backgroundColor = tracker.color
        addButton.backgroundColor = tracker.color
        bottomContainer.backgroundColor = .clear
    }
}

