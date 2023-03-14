import UIKit

final class HabitsViewController: UIViewController {
    
    private var store = HabitsStore.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сегодня"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .purple
        button.addTarget(self, action: #selector(addHabitAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collectionView.register(HabitCollectionViewCell.self,  forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.autoresizesSubviews = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        reloadData()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NotificationNames.habitDidCreate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NotificationNames.habitDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NotificationNames.habitDidDelete, object: nil)
        
        title = titleLabel.text
        [titleLabel, addButton, collectionView].forEach({ view.addSubview($0) })
        NSLayoutConstraint.activate([
            
            addButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppSettings.inset),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppSettings.inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppSettings.inset),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppSettings.inset),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func addHabitAction() {
        let vc = HabitViewController()
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true, completion: nil )
    }

    /// Обновляет ячейки коллекции. Если это реакция на уведомление, тогда обрабатываем его.
    @objc private func reloadData(_ notification: Notification? = nil) {
        collectionView.reloadData()
        if let notification = notification, let userInfo = notification.userInfo {
            if let newHabit = userInfo.values.first(where: { $0 is Habit }) as? Habit {
                if let index = store.habits.firstIndex(of: newHabit) {
                    // Индекс больше на 1 поскольку первая ячейка HabitCollectionViewCell:
                    collectionView.selectItem(at: IndexPath(item: index + 1, section: 0), animated: true, scrollPosition: .centeredVertically)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationNames.habitDidCreate, object: nil)
        NotificationCenter.default.removeObserver(self, name: NotificationNames.habitDidUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: NotificationNames.habitDidDelete, object: nil)
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
            cell.setProgress(store.todayProgress)
            cell.cellWidth = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as! HabitCollectionViewCell
            cell.cellWidth = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            cell.setHabit(store.habits[indexPath.row - 1])
            return cell
        }
    }
}

extension HabitsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let index = indexPath.row - 1
            if (0..<store.habits.count).contains(index) {
                let vc =  HabitDetailsViewController(habit: store.habits[index])
                navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}

