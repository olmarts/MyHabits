import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    static private(set) var mainTabBar: MainTabBarController? = nil
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootVC = MainTabBarController()
        window?.rootViewController = rootVC
        SceneDelegate.mainTabBar = rootVC
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}


