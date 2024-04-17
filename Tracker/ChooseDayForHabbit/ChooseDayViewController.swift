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
        tableView.backgroundColor = UIColor(named: "GrayForNavBar")
    }
    
    private func configureConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
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
        cell.dayLabel.text = day.rawValue
        return cell
    }
}

extension ChooseDayViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
