import UIKit

final class HabitDetailTableViewCell: UITableViewCell {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private let checkBox: CustomCheckbox = {
        let checkBox = CustomCheckbox()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.checkedImage = UIImage(systemName: "checkmark")
        checkBox.backgroundColor = .clear
        return checkBox
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindModel(date: String?, isTracked: Bool) {
        dateLabel.text = date
        checkBox.isChecked = isTracked
    }
    
    private func layout() {
        [dateLabel, checkBox].forEach({ addSubview($0) })
        
        NSLayoutConstraint.activate([
            
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppSettings.inset),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSettings.inset),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSettings.inset * 3.5),
            
            checkBox.centerYAnchor.constraint(equalTo:  dateLabel.centerYAnchor),
            checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSettings.inset),
            checkBox.heightAnchor.constraint(equalToConstant: AppSettings.inset * 2),
            checkBox.widthAnchor.constraint(equalToConstant: AppSettings.inset * 2),
        ])
    }
    
}
