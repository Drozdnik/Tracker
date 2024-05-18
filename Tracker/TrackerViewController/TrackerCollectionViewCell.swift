//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Михаил  on 21.04.2024.
//

import Foundation
import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    var onIncrementCount: ((IndexPath) -> Void)?
    var indexPath: IndexPath?
    var isCompleted: Bool = false
    var completedTrackers: [TrackerRecord] = []
    var selectedDate: Date = Date()
    
    // Элементы UI для верхней секции
    private lazy var emojiLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var topContainer = UIView()
    private var countOfDays: String = ""
    // Элементы UI для нижней секции
    private let dayLabel = UILabel()
    let addButton = UIButton()
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
        addButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        addButton.tintColor = .white
        emojiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .white
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textAlignment = .left
        
        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -12),
            
            bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 58),
            
            dayLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 12),
            dayLabel.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -12),
            addButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureWith(tracker: Tracker, completedTrackers: [TrackerRecord], currentDate: Date) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        topContainer.backgroundColor = tracker.color
        addButton.backgroundColor = tracker.color
        countOfDays = getDayText(count: tracker.countOfDoneTrackers)
        dayLabel.text = "\(countOfDays)"
        addButton.layer.opacity = 1
        self.completedTrackers = completedTrackers
        
        isCompleted = completedTrackers.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        
        updateButtonAppearance()
    }
    
    func updateButtonAppearance() {
        if isCompleted {
            let configuration = UIImage.SymbolConfiguration(weight: .bold)
            let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: configuration)
               addButton.setImage(checkmarkImage, for: .normal)
            
            addButton.layer.opacity = 0.3
        } else {
            addButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addButton.isEnabled = true
        }
    }
    
    func getNoun(number: Int, one: String, two: String, five: String) -> String {
        let n = abs(number) % 100
        if n >= 5 && n <= 20 {
            return five
        }
        switch n % 10 {
        case 1:
            return one
        case 2...4:
            return two
        default:
            return five
        }
    }
    
    
    func getDayText(count: Int) -> String {
        return "\(count) " + getNoun(number: count, one: "день", two: "дня", five: "дней")
    }
    
    @objc func plusButtonTapped() {
        if let indexPath = indexPath {
            onIncrementCount?(indexPath)
        }
    }
}

extension Date {
    func weekdayIndex() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self) - 2
    }
}
