import UIKit
class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var statistics: [(title: String, value: String)] = []
    private var isEmpty: Bool = true
    let statisticsTitle = NSLocalizedString("statistics_title", comment: "Title for the statistics screen")
    let noDataMessage = NSLocalizedString("no_data_message", comment: "Message shown when there is no data to analyze")
    
    private lazy var emptyScreenImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "EmptyStatistics"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyScreenText: UILabel = {
        let label = UILabel()
        label.text = noDataMessage
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyScreenView: UIView = {
        let view = UIView()
        view.addSubview(emptyScreenImage)
        view.addSubview(emptyScreenText)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = statisticsTitle
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: "StatisticCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatistics), name: .didUpdateCompletedTrackers, object: nil)
        view.backgroundColor = UIColor.systemBackground
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        fetchAndDisplayStatistics()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    private func addSubviews() {
        view.addSubview(emptyScreenView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenText.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            emptyScreenText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchAndDisplayStatistics() {
        let stats = DataManager.shared.computeTotalCompletedTrackers()
        let trackersCompleted = NSLocalizedString("Trackers_Completed", comment:"")
        statistics = [
            (title: trackersCompleted, value: "\(stats)")
        ]
        isEmpty = stats == 0
        tableView.isHidden = isEmpty
        emptyScreenView.isHidden = !isEmpty
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCell", for: indexPath) as? StatisticTableViewCell else {
               return UITableViewCell()
           }
           let statistic = statistics[indexPath.row]
           cell.configure(with: statistic)
           return cell
       }
       

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateStatistics() {
        fetchAndDisplayStatistics()
    }
}
