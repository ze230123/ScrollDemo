//
//  BaseTabBarViewController.swift
//  
//
//  Created by 张泽群 on 2022/11/15.
//

import UIKit

open class BaseTabBarController: UITabBarController {
    open override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }

    open override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    public var uTabbar: TabBar {
        return tabBar as! TabBar
    }

    open func selectTab(at index: Int) {
        uTabbar.selectButton(at: index)
    }
}

public extension UIViewController {
    private struct Key {
        static var item = "barItem"
    }

    /// 自定义Tabbar按钮数据
    var uTabBarItem: TabBarItem? {
        get {
            return withUnsafePointer(to: &Key.item) { pointer in
                return objc_getAssociatedObject(self, pointer) as? TabBarItem
            }
        }
        set {
            withUnsafePointer(to: &Key.item) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    var uTabbarController: BaseTabBarController? {
        return tabBarController as? BaseTabBarController
    }
}
