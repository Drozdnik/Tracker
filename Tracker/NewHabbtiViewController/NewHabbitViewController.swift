
import Foundation
import UIKit

final class NewHabbitViewController: UIViewController{
    var trackerType: TrackerType = .habit
    var newHabbitComplete: ((String, Tracker) -> Void)?
    private var habitName: String = ""
    private var habitCategory: String = ""
    private var habitSchedule: Schedule = Schedule(days: Array(repeating: false, count: 7))
    private  var habitEmoji: String = ""
    private var habitColor: UIColor = .white
    
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
        updateCreateButtonState()
        //Регестрируем ячейку таблицы и коллекция
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        emojiCollectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        
        colorCollectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
    }
    
    
    private func setupContentView(){
        contentView.addSubviews([tableView, textField, characterLimitLabel,  emojiCollectionView, colorCollectionView, cancelButton, createButton])
        configureConstraintsForContentView()
    }
    
    private func configureNavBar(){
        if trackerType == .habit{
            navigationItem.title = "Новая привычка"
        } else if trackerType == .irregularEvent {
            navigationItem.title = "Новое нерегулярное событие"
        }
       
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    private func setupTableView(){
        textField.delegate = self
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
        ])
    }
    
    private func configureConstraintsForContentView(){
        let heightConstants: CGFloat = trackerType == .habit ? 149 : 75
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 63),
            
            characterLimitLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            characterLimitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: heightConstants),
            
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 250), 
            
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
 
    private lazy var textField: UITextView = {
        let textView = UITextView()
        textView.text = "Введите название трекера"
        textView.textAlignment = .left
        
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = UIColor(named: "GrayForNavBar")
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.cornerRadius = 16
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 12, right: 12)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var characterLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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

extension NewHabbitViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                habitName = textView.text
                textView.resignFirstResponder()
                updateCreateButtonState()
                return false
            }
            
            // Проверка на количество символов
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            
            if changedText.count > 38 {
                characterLimitLabel.isHidden = false
                return false
            } else {
                characterLimitLabel.isHidden = true
            }
            return true  
        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black 
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите название трекера"
            textView.textColor = UIColor.lightGray
        }
    }
}
//Таблица
extension NewHabbitViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerType == .habit ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = habitCategory
        } else if indexPath.row == 1{
            cell.textLabel?.text = "Расписание"
            cell.detailTextLabel?.text = self.habitSchedule.dayToShortDay()
        }
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .gray
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
        if indexPath.row == 0 {
            let vc = ChooseTrackerTitleView()
            let navigationController = UINavigationController(rootViewController: vc)
            vc.delegate = self
            present(navigationController, animated: true)
            let categoryIndexPath = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [categoryIndexPath], with: .none)
            updateCreateButtonState()
        } else if indexPath.row == 1 {
            let vc = ChooseDayViewController()
            vc.schedule = self.habitSchedule
            vc.scheduleUpdated = { [weak self] updatedShedule in
                guard let self else {return}
                self.habitSchedule = updatedShedule
                
                let scheduleIndexPath = IndexPath(row: 1, section: 0)
                tableView.reloadRows(at: [scheduleIndexPath], with: .none)
                self.habitSchedule = updatedShedule
                updateCreateButtonState()
            }
            let navigationController = UINavigationController(rootViewController: vc)
            present(navigationController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if trackerType == .irregularEvent{
            let cornerRadius: CGFloat = 10
            tableView.separatorStyle = .none
            cell.layer.cornerRadius = cornerRadius
            cell.layer.masksToBounds = true
            
            if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
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
        return CGSize(width: collectionView.bounds.width / 6, height: 52)  
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.emojiCollectionView {
            self.habitEmoji = emojiList[indexPath.item]
            updateCreateButtonState()
        } else if collectionView == self.colorCollectionView {
            self.habitColor = colorList[indexPath.item]
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
            updateCreateButtonState()
            cell.setSelectedState(with: self.habitColor)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
        cell.setDeselectedState()
    }
}

extension NewHabbitViewController{
    private func updateCreateButtonState(){
        let isFormComplete = !habitName.isEmpty &&
        !habitEmoji.isEmpty &&
        habitColor != UIColor.white &&
        !habitCategory.isEmpty &&
        (trackerType != .irregularEvent ? habitSchedule.days.contains(true) : true)
        createButton.isEnabled = isFormComplete
        createButton.backgroundColor = isFormComplete ? .black : UIColor(named: "GrayForCreateButton")
    }
    
    @objc  private func didTapCancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCreateButton(){
        let newTracker = Tracker (
            id: UUID(),
            name: habitName,
            color: habitColor,
            emoji: habitEmoji,
            schedule: habitSchedule,
            countOfDoneTrackers: 0
        )
        
        
        
        newHabbitComplete?(habitCategory ,newTracker)
        dismiss(animated: true)
    }
}

extension NewHabbitViewController: SelectedCategoryPassDelegate{
    func selectedCategoryPass(selectedCategory: String) {
        habitCategory = selectedCategory
        updateCreateButtonState()
        tableView.reloadData()
    }
}
