//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by Михаил  on 09.04.2024.
//

import Foundation
import UIKit

final class NewHabbitViewController: UIViewController{
    let scrollView = UIScrollView()
    let contentView = UIView()
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupContentView()
        configureNavBar()
        setupTableView()
        configureConstraintsForContentView()
        //Регестрируем ячейку  таблицы
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func setupContentView(){
        contentView.addSubview(tableView)
        contentView.addSubview(textField)
        configureConstraintsForContentView()
    }
    
    private func configureConstraintsForContentView(){
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.widthAnchor.constraint(equalToConstant: 286),
            textField.heightAnchor.constraint(equalToConstant: 63),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 150)
//            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 425)
        ])
    }
    // Сделать ext для UIViewController и вызывать оттуда configureNavBar(title)
    private func configureNavBar(){
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    private func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Введите название трекера"
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor(named: "GrayForNavBar")
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
}

extension NewHabbitViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = indexPath.row == 0 ? "Категория" : "Расписание"
        cell.textLabel?.textColor = .black
        cell.backgroundColor = UIColor(named: "GrayForNavBar")
    
        return cell
    }
}

extension NewHabbitViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
