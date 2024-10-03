//
//  TabBarController.swift
//
//

import Foundation

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let tabBarHeight: CGFloat = 80
    private var tabItems: [UIViewController] = []
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItems()
        setTabBarUI()
        setTabBarHeight()
    }
    
}

private extension TabBarController {
    
    func setTabBarItems() {
        let ongoingVC = UINavigationController(rootViewController: OngoingViewController())
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let achieveVC = UINavigationController(rootViewController: AchieveViewController())
        
        tabItems = [
            ongoingVC,
            homeVC,
            achieveVC
        ]
        
        TabBarItemType.allCases.forEach {
            let tabBarItem = $0.setTabBarItem()
            tabItems[$0.rawValue].tabBarItem = tabBarItem
            tabItems[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        let tabBarItemTitles: [String] = [I18N.TabBar.ongoing, I18N.TabBar.home, I18N.TabBar.achieve]
        
        for (index, tabTitle) in tabBarItemTitles.enumerated() {
            let tabBarItem = TabBarItemType(rawValue: index)?.setTabBarItem()
            tabItems[index].tabBarItem = tabBarItem
            tabItems[index].tabBarItem.tag = index
            tabItems[index].title = tabTitle
        }
        
        setViewControllers(tabItems, animated: false)
        selectedViewController = tabItems[1]
    }
    
    func setTabBarUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .Gray650
        tabBar.unselectedItemTintColor = .Gray300
    }
    
    func getSafeAreaBottomHeight() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let safeAreaInsets = windowScene.windows.first?.safeAreaInsets
            let bottomSafeAreaHeight = safeAreaInsets?.bottom ?? 0
            return bottomSafeAreaHeight
        }
        return 0
    }
    
    func setTabBarHeight() {
        if let tabBar = self.tabBarController?.tabBar {
            let safeAreaBottomInset = self.view.safeAreaInsets.bottom
            let tabBarHeight = tabBar.bounds.height
            let newTabBarFrame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y, width: tabBar.frame.width, height: tabBarHeight + safeAreaBottomInset)
            tabBar.frame = newTabBarFrame
        }
    }
}
