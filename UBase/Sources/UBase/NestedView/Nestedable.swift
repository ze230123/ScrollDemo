//
//  Nestedable.swift
//  
//
//  Created by 张泽群 on 2022/10/9.
//

import UIKit

/// 可嵌套协议
public protocol Nestedable: AnyObject {
    /// 内容视图
    var contentView: UIView { get }
    /// 自适应大小
    var intrinsicContentSize: CGSize { get }
    /// 是否隐藏
    var isHidden: Bool { get set }
    /// 内容视图frame
    var frame: CGRect { get set }
    /// 是否可以滚动
    var isScroll: Bool { get }
    /// 内容大小
    var contentSize: CGSize { get }
    /// 滚动位置
    var contentOffset: CGPoint { get set }
    /// 滚动视图内边距
    var contentInset: UIEdgeInsets { get }

    /// 必须使用 weak 修饰
    var superNestedView: NestedView? { get set }
}

// MARK: - UIView遵守协议默认实现
public extension Nestedable where Self: UIView {
    var contentView: UIView {
        return self
    }

    var contentSize: CGSize {
        return .zero
    }

    var isScroll: Bool {
        return false
    }

    var contentInset: UIEdgeInsets {
        return .zero
    }
}

// MARK: - UIViewController遵守协议默认实现
public extension Nestedable where Self: UIViewController {
    var contentView: UIView {
        return view
    }

    var isHidden: Bool {
        get {
            return view.isHidden
        }
        set {
            view.isHidden = newValue
        }
    }

    var frame: CGRect {
        get {
            return view.frame
        }
        set {
            view.frame = newValue
        }
    }
}
