import UIKit

enum Tabs {
    static let habits = (title: "Привычки", image: UIImage(systemName: "house.fill"))
    static let info   = (title: "Информация", image: UIImage(systemName:  "info.circle.fill"))
}

class MainTabBarController: UITabBarController {

    let navigationHabitsVC: UINavigationController = {
        let vc = HabitsViewController()
        vc.tabBarItem.title = Tabs.habits.title
        vc.tabBarItem.image = Tabs.habits.image
        return UINavigationController(rootViewController: vc)
    }()
    
    let navigationInfoVC: UINavigationController = {
        let vc = InfoViewController()
        vc.tabBarItem.title = Tabs.info.title
        vc.tabBarItem.image = Tabs.info.image
        vc.title = vc.tabBarItem.title
        return UINavigationController(rootViewController: vc)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ navigationHabitsVC, navigationInfoVC ]
    }
    
}

