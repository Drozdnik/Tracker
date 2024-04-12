//
//  ChooseDayViewController.swift
//  Tracker
//
//  Created by Михаил  on 12.04.2024.
//

import Foundation
import UIKit

final class ChooseDayViewController: UIViewController{
    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var doneButton:UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(named: "TotalBlack")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

extension ChooseDayViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        let day = Weekday.allCases[indexPath.row]
        cell.dayLabel.text = day.rawValue
        return cell
    }
}

extension ChooseDayViewController:UITableViewDelegate{
}
