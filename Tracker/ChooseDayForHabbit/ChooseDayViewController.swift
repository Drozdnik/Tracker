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
        
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubViews()
        configureConstraints()
        configureNavBar()
    }
    
    private func addSubViews(){
        view.addSubviews([tableView, doneButton])
        view.backgroundColor = .white
        
        tableView.isScrollEnabled = false
        // Для того чтобы убрать вехнюю разделительную линию
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: CGFloat.leastNormalMagnitude))
    }
    
    private func configureConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 524),
            
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 25),
            doneButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            //            doneButton.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    private func configureNavBar(){
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
        cell.backgroundColor = UIColor(named: "GrayForTableViews")?.withAlphaComponent(0.3)
        cell.dayLabel.text = day.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 0
        cell.layer.maskedCorners = []
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }

}

extension ChooseDayViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
