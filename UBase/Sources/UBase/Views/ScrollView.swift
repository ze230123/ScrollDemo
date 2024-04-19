//
//  ScrollView.swift
//  YouZhiYuan
//
//  Created by youzy01 on 2020/7/29.
//  Copyright © 2020 泽i. All rights reserved.
//

import UIKit

/// 自定义滚动视图
///
/// 可用于嵌套`PageView`，绘制微博个人中心类似的页面
/// 嵌套是需要设置`ignoreViews`，已防止同时识别页面中其他横向滚动视图手势
open class ScrollView: UIScrollView, UIGestureRecognizerDelegate {
    /// 忽略手势的UIScrollView数组，**注意：需要提供`UIScrollView`**
    public var ignoreGestureViews: [UIView?] = []
    /// 是否允许同时识别其他手势
    @IBInspectable public var isAllowOtherGestureRecognizer: Bool = false

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if ignoreGestureViews.contains(otherGestureRecognizer.view) {
            return false
        } else if let scrollView = otherGestureRecognizer.view as? UIScrollView, scrollView.isIgnoreGesture {
            return false
        }
        return isAllowOtherGestureRecognizer
    }
}

private var ignoreGestureKey = "ignoreGestureKey"

public extension UIScrollView {
    /// 是否忽略横向滑动手势
    ///
    /// ScrollView嵌套视图时使用，避免多个视图同时滑动，true: 忽略
    @IBInspectable var isIgnoreGesture: Bool {
        get {
            withUnsafePointer(to: &ignoreGestureKey) { pointer in
                return (objc_getAssociatedObject(self, pointer) as? Bool) ?? false
            }
        }
        set {
            withUnsafePointer(to: &ignoreGestureKey) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

