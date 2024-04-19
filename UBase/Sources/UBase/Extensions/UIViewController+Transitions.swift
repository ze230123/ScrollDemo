//
//  UIViewController+Transitions.swift
//  NetWork
//
//  Created by 泽i on 2018/8/13.
//  Copyright © 2018年 泽i. All rights reserved.
//

import UIKit

public extension UIViewController {
    func push(_ vc: UIViewController, animated: Bool = true) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: animated)
    }

    func present(_ vc: UIViewController, animated: Bool = true) {
        self.present(vc, animated: animated, completion: nil)
    }

    func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    func popToViewController(vc: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(vc, animated: true)
    }
}

// MARK: - UIViewController Extension
public extension UIViewController {
    // 获取app当前最顶层的ViewController
    static var appTopVC: UIViewController? {
        var resultVC: UIViewController?
        resultVC = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController?.topVC
        while resultVC?.presentedViewController != nil {
            resultVC = resultVC?.presentedViewController?.topVC
        }
        return resultVC
    }

    var topVC: UIViewController? {
        if self.isKind(of: UINavigationController.self) {
            return (self as! UINavigationController).topViewController?.topVC
        } else if self.isKind(of: UITabBarController.self) {
            return (self as! UITabBarController).selectedViewController?.topVC
        } else {
            return self
        }
    }
}
