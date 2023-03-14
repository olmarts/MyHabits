import UIKit

final class HabitCollectionViewCell: CustomCollectionViewCell {

    private lazy var model: Habit? = nil
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 10
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .natural
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .systemGray
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var checkBox: CustomCheckbox = {
        let checkBox = CustomCheckbox()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        let imgConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22, weight: .regular))
        checkBox.checkedImage = UIImage(systemName: "checkmark", withConfiguration: imgConfiguration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        checkBox.bgColors = (checked: .systemIndigo, unchecked: .clear)
        checkBox.layer.cornerRadius = Metric.checkBox.radius
        checkBox.layer.borderColor = UIColor.purple.cgColor
        checkBox.layer.borderWidth = 0.5
        checkBox.addTarget(self, action: #selector(self.setTracked), for: .touchUpInside)
        return checkBox
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        [nameLabel, dateLabel, checkBox, counterLabel].forEach({ addSubview($0) })
        NSLayoutConstraint.activate([

            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSettings.inset),
            checkBox.heightAnchor.constraint(equalToConstant: Metric.checkBox.width),
            checkBox.widthAnchor.constraint(equalToConstant: Metric.checkBox.height),

            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metric.topInset),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSettings.inset),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -(Metric.checkBox.width + AppSettings.inset + 8)),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Metric.topInset),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSettings.inset),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -(Metric.checkBox.width + AppSettings.inset + 8)),

            counterLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Metric.topInset),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSettings.inset),
            counterLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -(Metric.checkBox.width + AppSettings.inset + 8)),
            counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppSettings.inset),
        ])
    }
    
    func setHabit(_ habit: Habit) {
        model = habit
        bindModel()
    }
    
    private func bindModel() {
        if let habit = model {
            nameLabel.text = habit.name
            nameLabel.textColor = habit.color
            dateLabel.text = habit.dateString
            checkBox.isChecked = habit.isAlreadyTakenToday
            counterLabel.text =  "Счётчик: \(habit.trackDates.count)"
        }
    }
    
    @objc private func setTracked() {
        if let habit = model {
            checkBox.toggle()
            HabitsStore.shared.track(habit)
            bindModel()
            NotificationCenter.default.post(name: NotificationNames.habitDidUpdate, object: nil)
        }
    }
}

extension HabitCollectionViewCell {

    private enum Metric {
        static let topInset: CGFloat = 8
        static let checkBox: (width: CGFloat, height: CGFloat, radius: CGFloat) = (40, 40, 20)

    }
}
