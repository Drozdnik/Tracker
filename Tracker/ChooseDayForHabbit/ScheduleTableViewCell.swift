//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Михаил  on 12.04.2024.
//

import Foundation
import UIKit

final class ScheduleTableViewCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dayLabel)
        contentView.addSubview(daySwitch)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let identifier = "ScheduleTableViewCell"
    
    lazy var dayLabel: UILabel = { // вот тут может упасть тк lazy
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()
    
    private func configureView() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
