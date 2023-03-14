import UIKit

final class HabitDetailsViewController: UIViewController {
    
    private var model: Habit
    private lazy var dates: [Date] = {
        return HabitsStore.shared.dates.sorted { $0 > $1 }
    }()
    
    private let headerTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "header")
        cell.textLabel?.text = "Активность".uppercased()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return cell
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HabitDetailTableViewCell.self, forCellReuseIdentifier: HabitDetailTableViewCell.identifier)
        return tableView
    }()
    
    init(habit: Habit) {
        model = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc private func bindModel() {
        navigationItem.title = model.name
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .purple
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editHabitAction))
    }
    
    private func setup() {
        view.backgroundColor = .systemGray4
        NotificationCenter.default.addObserver(self, selector: #selector(bindModel), name: NotificationNames.habitDidUpdate, object: nil)
        bindModel()
        setupNavBar()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func editHabitAction() {
        let navController = UINavigationController(rootViewController: HabitViewController(habit: model))
        navigationController?.present(navController, animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HabitDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: HabitDetailTableViewCell.identifier, for: indexPath) as! HabitDetailTableViewCell
        let day = dates[indexPath.row]
        let isTracked = HabitsStore.shared.habit(model, isTrackedIn: day)
        cell.bindModel(date: HabitsStore.shared.dateFormatter.string(from: day), isTracked: isTracked)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? headerTableViewCell : nil
    }
}
