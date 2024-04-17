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
        //Регестрируем ячейку таблицы и коллекция
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        emojiCollectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        
        colorCollectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
    }
    
    
    private func setupContentView(){
        contentView.addSubviews([tableView, textField, emojiCollectionView, colorCollectionView, cancelButton, createButton])
        configureConstraintsForContentView()
    }
    
    private func configureNavBar(){
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    private func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
    
    private func setupScrollView() {
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
    
    private func configureConstraintsForContentView(){
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 63),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 149),
            
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojiCollectionView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 250), // по макету 374
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 0),
            colorCollectionView.leadingAnchor.constraint(equalTo: emojiCollectionView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: emojiCollectionView.trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 250),

            
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            createButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.trailingAnchor.constraint(equalTo: colorCollectionView.trailingAnchor)
        ])
    }
    
    
    // Сделать ext для UIViewController и вызывать оттуда configureNavBar(title)
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
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: 52, height: 52)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
       let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button .addTarget(self, action: #selector (didTapCreateButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "TotalBlack")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
//Таблица
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)

            if indexPath.row == 1 {
                let vc = ChooseDayViewController()
                let navigationController = UINavigationController(rootViewController: vc)
                present(navigationController, animated: true)
            }
        }
}
// Коллекция
extension NewHabbitViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCollectionViewCell
            
            let emoji = emojiList[indexPath.row]
            cell.configure(with: emoji)
            return cell
        } else if collectionView === colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCollectionViewCell
            let color = colorList[indexPath.row]
            cell.configure(with: color)
            return cell
        }
        fatalError("Unexpected collection view")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
            
            if collectionView == emojiCollectionView{
                header.configure(with: "Emoji")
            } else if collectionView == colorCollectionView{
                header.configure(with: "Цвет")
            }
            return header
        default:
            assert(false, "Ошбика")
        }
    }
}

extension NewHabbitViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === emojiCollectionView {
            return emojiList.count
        } else {
            return colorList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 1
        return CGSize(width: collectionView.bounds.width / 6, height: 52)   // 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
        cell.setSelectedState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
        cell.setDeselectedState()
    }
}

extension NewHabbitViewController{
    @objc  private func didTapCancelButton(){
    }
    
    @objc private func didTapCreateButton(){
        
    }
}

