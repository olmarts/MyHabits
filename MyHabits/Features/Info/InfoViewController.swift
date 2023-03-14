import UIKit

final class InfoViewController: UIViewController {
    
    private let model: [String] = {
        return [
            "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:",
            "Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.",
            "Выдержать 2 дня в прежнем состоянии самоконтроля.",
            "Отметить в дневнике первую неделю изменений и подвести первые итоги - что оказалось тяжело, что - легче, с чем еще предстоит серьезно бороться.",
            "Поздравить себя с прохождением первого серьезного порога в 21 день.\nЗа это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.",
            "Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.",
            "На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.",
        ]
    }()
    
    private let headerTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "header")
        cell.textLabel?.text = "Привычка за 21 день"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return cell
    }()
    
    private let footerTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "footer")
        cell.textLabel?.text = "Источние: psychbook.ru"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return cell
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: self), for: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? model[indexPath.row] : "\(indexPath.row). \(model[indexPath.row])"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? headerTableViewCell : nil
    }
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 0 ? footerTableViewCell : nil
    }
}




