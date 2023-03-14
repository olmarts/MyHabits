import UIKit

final class HabitViewController: UIViewController {
    
    private var model: Habit
    private let notification = NotificationCenter.default
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "НАЗВАНИЕ"
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.purple.cgColor
        textField.layer.borderWidth = 1
        textField.backgroundColor = .white
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.placeholderColor(.black, alpha: 0.5)
        textField.setPadding(left: 16, right: 16)
        return textField
    }()
    
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "ЦВЕТ"
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = view.bounds.width/2
        view.backgroundColor = .black
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapColorViewAction)))
        return view
    }()
    
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "ВРЕМЯ"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .time
        datePicker.layer.borderColor = UIColor.gray.cgColor
        datePicker.layer.borderWidth = 1
        datePicker.layer.cornerRadius = 10
        datePicker.tintColor = .purple
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.purple.cgColor
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - if a habit is nil then this action is "Create new" else "Edit".
    init(habit: Habit? = nil) {
        model = habit ?? Habit(name: "", date: Date(), color: .black)
        super.init(nibName: nil, bundle: nil)
        deleteButton.isHidden = habit == nil
        navigationItem.title = habit == nil ? "Добавить" : "Править"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func bindModel() {
        nameTextField.text = model.name
        colorView.backgroundColor = model.color
        dateLabel.text = model.dateString
        datePicker.date = model.date
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .purple
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(closeAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveAction))
    }
    
    private func setup() {
        view.backgroundColor = .systemGray4
        bindModel()
        setupNavBar()
        [scrollView, deleteButton].forEach({ view.addSubview($0) })
        scrollView.addSubview(contentView)
        [nameTitleLabel, nameTextField, colorTitleLabel, colorView, timeTitleLabel, dateLabel, datePicker].forEach({ contentView.addSubview($0) })
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppSettings.inset),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppSettings.inset),
            deleteButton.heightAnchor.constraint(equalToConstant: 45),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppSettings.inset),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            nameTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: AppSettings.inset * 2),
            nameTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSettings.inset),
            nameTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSettings.inset),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: AppSettings.inset/2),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSettings.inset),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSettings.inset),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            colorTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: nameTextField.bottomAnchor, constant: AppSettings.inset * 2),
            colorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSettings.inset),
            colorTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSettings.inset),
            
            colorView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: AppSettings.inset/2),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSettings.inset),
            colorView.widthAnchor.constraint(equalToConstant: 30),
            colorView.heightAnchor.constraint(equalToConstant: 30),
            
            timeTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: colorView.bottomAnchor, constant: AppSettings.inset * 2),
            timeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSettings.inset),
            timeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSettings.inset),
            
            dateLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: AppSettings.inset/2),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSettings.inset),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSettings.inset),
            
            datePicker.topAnchor.constraint(greaterThanOrEqualTo: dateLabel.bottomAnchor, constant: AppSettings.inset/2),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSettings.inset),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSettings.inset),
            datePicker.heightAnchor.constraint(equalToConstant: 150),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppSettings.inset),
            
        ])
    }
    
    @objc private func tapColorViewAction() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = colorView.backgroundColor ?? .black
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        model.date = sender.date
        dateLabel.text = model.dateString
    }
    
    @objc private func saveAction() {
        guard var name = nameTextField.text else { return }
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty { return }
        model.name = name
        if deleteButton.isHidden {
            HabitsStore.shared.habits.append(model)
            HabitsStore.shared.save()
            notification.post(name: NotificationNames.habitDidCreate, object: nil, userInfo: ["habit": model])
        } else {
            HabitsStore.shared.save()
            notification.post(name: NotificationNames.habitDidUpdate, object: nil, userInfo: ["habit": model])
        }
        closeAction()
    }
    
    @objc private func deleteAction() {
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку\n\"\(model.name)\"?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отменить", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: .default, handler:  { _ in
            HabitsStore.shared.habits.removeAll(where: { $0 == self.model })
            HabitsStore.shared.save()
            self.notification.post(name: NotificationNames.habitDidDelete, object: nil)
            self.dismiss(animated: true, completion: {
                // после закрытия модального окна переходим на главный контроллер:
                SceneDelegate.mainTabBar?.navigationHabitsVC.popToRootViewController(animated: false)
            })
        }))
        present(alert, animated: true)
    }
    
    @objc private func closeAction() {
        dismiss(animated: true)
    }
}

extension HabitViewController: UITextFieldDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notification.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notification.removeObserver(UIResponder.keyboardWillShowNotification)
        notification.removeObserver(UIResponder.keyboardWillHideNotification)
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keybordSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keybordSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keybordSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorView.backgroundColor = viewController.selectedColor
        model.color = viewController.selectedColor
    }
}

