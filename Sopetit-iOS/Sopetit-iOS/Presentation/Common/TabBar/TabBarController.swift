//
//  TabBarController.swift
//
//

import Foundation

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let tabBarHeight: CGFloat = 80
    private var tabItems: [UIViewController] = []
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray950
        view.isHidden = true
        return view
    }()
    
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
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        self.tabBar.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPopup), name: Notification.Name("showPopup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidePopup), name: Notification.Name("hidePopup"), object: nil)
    }
    
    @objc func showPopup() {
        self.backgroundView.isHidden = false
    }
    
    @objc func hidePopup() {
        self.backgroundView.isHidden = true
    }
}
