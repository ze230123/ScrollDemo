//
//  File.swift
//  
//
//  Created by youzy01 on 2020/10/9.
//

import MBProgressHUD

extension UIApplication {
    /// The app's key window taking into consideration apps that support multiple scenes.
    var uKeyWindow: UIWindow? {
        return windows.first(where: \.isKeyWindow)
    }
}

/// HUD 提示
public struct UHUD {
    /// hud隐藏完成
    public typealias Completion = () -> Void

    public enum Style {
        /// 全屏
        case full
        /// 中等大小
        case medium
    }

    public static var loadViewType: LoadAnimateable.Type!
    public static var errorViewType: ErrorViewType.Type!
    public static var emptyViewType: ListViewDataEmptyType.Type!

    public static func showError(_ error: Error, inView: UIView?, handler: ErrorHandler) {
        guard let view = inView else { return }
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView

        assert(errorViewType != nil, "请对 UHUD.errorViewType 赋值")

        let errorView = errorViewType.init()

        errorView.showError(error) { [weak handler, weak hud] in
            handler?.onReTry()
            hud?.hide(animated: true)
        }

        hud.customView = errorView

        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.white

        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.white
    }

    public static func showLoading(in view: UIView?, style: Style = .full, animate: Bool  = true) {
        guard let view = view else { return }
        MBProgressHUD.hide(for: view, animated: false)

        let hud = MBProgressHUD.showAdded(to: view, animated: animate)
        hud.mode = .customView

        assert(loadViewType != nil, "请对 UHUD.loadViewType 赋值")

        let loadView = loadViewType.init()

        loadView.start()

        hud.customView = loadView

        if case .medium = style {
            hud.label.text = "加载中..."
        }

        hud.backgroundView.style = .solidColor

        switch style {
        case .full:
            hud.backgroundView.color = UIColor.white
        case .medium:
            hud.backgroundView.color = UIColor(white: 0, alpha: 0.3)
        }

        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.white
    }

    public static func showEmpty(title: String, message: String, inView: UIView?) {
        guard let view = inView else { return }
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView

        assert(emptyViewType != nil, "请对 UHUD.emptyViewType 赋值")

        var appearance = emptyAppearance
        appearance?.text = title
        appearance?.detailText = message
        let emptyView = emptyViewType.init(appearance: appearance)

        hud.customView = emptyView

        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.white

        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.white
    }

    public static func hide(for view: UIView?, animated: Bool = true) {
        guard let view = view else { return }
        MBProgressHUD.hide(for: view, animated: animated)
    }
}

extension UHUD {
    /// 显示全屏HUD
    /// - Parameters:
    ///   - message: 信息
    ///   - animated: 是否动画
    ///   - delay: 延迟时间
    ///   - completion: 完成闭包
    public static func show(
        _ message: String,
        animated: Bool = true,
        delay: TimeInterval = 3,
        completion: Completion? = nil) {
        guard let view = UIApplication.shared.uKeyWindow else { return }

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor(white: 0, alpha: 0.8)

        hud.completionBlock = completion

        // 隐藏时候从父控件中移除
        hud.mode = .text
        hud.label.text = message
        hud.label.textColor = .white
        hud.label.numberOfLines = 0

        hud.hide(animated: animated, afterDelay: delay)
    }
}

extension UHUD {
    public enum Position {
        case top
        case center
        case bottom
    }

    public static func showMessage(_ text: String, to view: UIView?, animated: Bool = true, position: Position = .center, delay: TimeInterval = 2, completion: Completion? = nil) {
        guard let view = view else { return }

        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor(white: 0, alpha: 0.8)

        hud.completionBlock = completion

        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true
        hud.mode = .text
        hud.label.text = text
        hud.label.textColor = .white
        hud.label.numberOfLines = 0

        switch position {
        case .top:
            hud.offset = CGPoint(x: 0, y: -200)
        case .center:
            hud.offset = CGPoint(x: 0, y: 0)
        case .bottom:
            hud.offset = CGPoint(x: 0, y: MBProgressMaxOffset)
        }
        hud.hide(animated: animated, afterDelay: delay)
    }

    public static func showTips(_ text: String, to view: UIView, delay: TimeInterval = 3) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor(white: 0, alpha: 0.8)

        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true
        hud.mode = .text
        hud.label.text = text
        hud.label.textAlignment = .left
        hud.label.textColor = .white
        hud.label.numberOfLines = 0

        hud.hide(animated: true, afterDelay: delay)
    }
}
