//
//  UIButton+Extension.swift
//  BasicFramework
//
//  Created by dev-02 on 2018/8/15.
//  Copyright © 2018年 泽i. All rights reserved.
//

import UIKit

//public extension UIButton {
//    // 枚举图片的位置
//    @objc enum ButtonImageEdgeInsetsStyle: Int {
//        /// 上图下文字
//        case top
//        /// 左图右文字
//        case left
//        /// 下图上文字
//        case bottom
//        /// 右图左文字
//        case right
//    }
//
//    // MARK: 设置图片文字方向距离
//    func layoutButtonImageEdgeInsetsStyle(style: ButtonImageEdgeInsetsStyle, space: CGFloat) {
//        let imageWidth: CGFloat = imageView?.frame.size.width ?? 0
//        let imageHeight: CGFloat = imageView?.frame.size.height ?? 0
//
//        var labelWidth: CGFloat = 0
//        var labelHeight: CGFloat = 0
//
//        labelWidth = titleLabel?.intrinsicContentSize.width ?? 0
//        labelHeight = titleLabel?.intrinsicContentSize.height ?? 0
//
//        var imageEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
//        var labelEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
//
//        switch style {
//        case .top:
//            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space / 2.0, left: 0, bottom: 0, right: -labelWidth)
//            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-space / 2.0, right: 0)
//        case .left:
//            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
//            labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
//        case .bottom:
//            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
//            labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space / 2.0, left: -imageWidth, bottom: 0, right: 0)
//        case .right:
//            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
//            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth+space / 2.0)
//        }
//        self.titleEdgeInsets = labelEdgeInsets
//        self.imageEdgeInsets = imageEdgeInsets
//    }
//
//    /// 圆角
//    ///
//    /// - Parameters:
//    ///   - borderWidth: 边框宽度
//    ///   - borderColor: 边框颜色
//    ///   - cornerRadius: 圆角半径
//    ///   - titleColor: 字体颜色
//    func setButton(borderWidth: CGFloat, borderColor: UIColor?, cornerRadius: CGFloat) {
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
//        layer.masksToBounds = true
//        layer.borderWidth = borderWidth
//        layer.borderColor = borderColor?.cgColor
//        layer.cornerRadius = cornerRadius
//    }
//
//    /// 创建按钮
//    ///
//    /// - Parameters:
//    ///   - imageName: 图片
//    ///   - titleColor: 字体颜色
//    ///   - titleFont: 字体大小
//    ///   - backgroundColor: 背景颜色
//    ///   - title: 标题
//    /// - Returns: button
//    static func createButtonWith(imageName: String?, titleColor: UIColor?, titleFont: UIFont?, backgroundColor: UIColor?, title: String?) -> UIButton {
//        let button = UIButton(type: .custom)
//        button.backgroundColor = backgroundColor
//        if title?.count != nil {
//            button.setTitle(title, for: UIControl.State.normal)
//            button.setTitleColor(titleColor, for: UIControl.State.normal)
//        }
//        if titleFont != nil {
//            button.titleLabel?.font = titleFont
//        }
//        if (imageName?.count) != nil {
//            button.setImage(UIImage(named: imageName!), for: UIControl.State.normal)
//        }
//        return button
//    }
//}
//
//extension DispatchQueue {
//    private static var onceTracker = [String]()
//
//    public class func once(token: String, block:() -> Void) {
//        // 注意defer作用域，调用顺序——即一个作用域结束，该作用域中的defer语句自下而上调用。
//        objc_sync_enter(self)
//        defer {
//            // print("线程锁退出")
//            objc_sync_exit(self)
//        }
//
//        if onceTracker.contains(token) {
//            return
//        }
//        onceTracker.append(token)
//        block()
//    }
//}
//
//extension UIButton {
//
//    private struct RuntimeKey {
//         static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "clickEdgeInsets".hashValue)
//     }
//
//    /// 需要扩充的点击边距
//    public var clickEdgeInsets: UIEdgeInsets? {
//        get {
//            return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
//        }
//        set {
//            objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
//        }
//    }
//
//    // 重写系统方法修改点击区域
//    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        super.point(inside: point, with: event)
//        var bounds = self.bounds
//        if let inset = clickEdgeInsets {
//            let x: CGFloat = -inset.left
//            let y: CGFloat = -inset.top
//            let width: CGFloat = bounds.width + inset.left + inset.right
//            let height: CGFloat = bounds.height + inset.top + inset.bottom
//            bounds = CGRect(x: x, y: y, width: width, height: height) // 负值是方法响应范围
//        }
//        return bounds.contains(point)
//    }
//}
