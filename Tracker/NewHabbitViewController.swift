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
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupContentView(){
        contentView.addSubview(textField)
        contentView.addSubview(tableView)
        configureConstraintsForContentView()
    }
    
    private func configureConstraintsForContentView(){
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 425)
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
        //        NSLayoutConstraint.activate([
        //            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
        //            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
        //            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
        //            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        //        ])
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите название трекера"
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
        cell.backgroundColor = .lightGray
        // Добавление разделительной линии
        //        if indexPath.row == 0 {
        //                  let separatorView = UIView(frame: CGRect(x: 0, y: cell.frame.size.height - 1, width: cell.frame.size.width, height: 1))
        //                  separatorView.backgroundColor = .lightGray // Или любой другой цвет
        //                  separatorView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        //                  cell.addSubview(separatorView)
        //              }
        return cell
    }
}

extension NewHabbitViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
