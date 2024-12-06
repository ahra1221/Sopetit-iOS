//
//  MakeAlert.swift
//  Sopetit-iOS
//
//  Created by 고아라 on 2023/12/29.
//

import UIKit

extension UIViewController {
    
    func makeSessionExpiredAlert() {
        makeVibrate()
        let alertViewController = UIAlertController(
            title: I18N.SessionExpiredAlert.title,
            message: I18N.SessionExpiredAlert.message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.moveToLoginView()
        }
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func makeServerErrorAlert() {
        makeVibrate()
        let alertViewController = UIAlertController(
            title: "네트워크가 원활하지 않아요.",
            message: "원활한 앱 사용을 위해\n다시 시도 해주세요.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.moveToSplashView()
        }
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func moveToLoginView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else {
            return
        }
        
        let nav = UINavigationController(rootViewController: LoginViewController())
        keyWindow.rootViewController = nav
    }
    
    private func moveToSplashView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else {
            return
        }
        
        let nav = UINavigationController(rootViewController: SplashViewController())
        keyWindow.rootViewController = nav
    }
}
