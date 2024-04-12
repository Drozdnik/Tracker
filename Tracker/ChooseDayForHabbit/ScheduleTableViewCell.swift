//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Михаил  on 12.04.2024.
//

import Foundation
import UIKit

final class ScheduleTableViewCell: UITableViewCell{
    static let identifier = "ScheduleTableViewCell"
    
    lazy var dayLabel: UILabel = { // вот тут может упасть тк lazy
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let switchControl = UISwitch()
        return daySwitch
    }()
    
    
}
