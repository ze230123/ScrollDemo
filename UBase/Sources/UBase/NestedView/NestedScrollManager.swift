//
//  NestedScrollManager.swift
//  YouZhiYuan
//
//  Created by youzy01 on 2020/7/30.
//  Copyright © 2020 泽i. All rights reserved.
//

import UIKit

/// 嵌套视图滚动管理（用于顶部有头视图的情况）
open class NestedScrollManager {
    /// 主视图
    private var mainScrollView: ScrollView
    /// 头视图
    private var headerView: UIView
    
    // 头部视图与子视图之间预留间距
    public var betweenHeight: CGFloat = 0
    /// 子视图
    private var childScrollView: UIScrollView?
    /// 主视图滚动观察
    private var mainScrollViewObservation: NSKeyValueObservation?
    /// 子视图滚动观察
    private var childScrollViewObservation: NSKeyValueObservation?
    private var childScrollViewContentObservation: NSKeyValueObservation?
    /// 记录当前子类 是否滑动状态
    private var childViews: [UIScrollView?] = []

    deinit {
        mainScrollViewObservation = nil
        childScrollViewObservation = nil
    }

    /// 初始化
    /// - Parameters:
    ///   - mainScrollView: 嵌套最外层ScrollView
    ///   - headerView: 头视图
    ///   - ignoreView: 横向滑动ScrollView，手势穿透时需要忽略，防止垂直、横向同时滑动
    public init(mainScrollView: ScrollView, headerView: UIView, ignoreGestureViews: [UIScrollView?]) {
        mainScrollView.eg_isCanScroll = true
        mainScrollView.isAllowOtherGestureRecognizer = true
        mainScrollView.ignoreGestureViews = ignoreGestureViews

        self.mainScrollView = mainScrollView
        self.headerView = headerView

        setupMainScrollViewObservation()
    }

    public func scrollsToTop() {
        mainScrollView.eg_isCanScroll = true
        childScrollView?.eg_isCanScroll = false
        mainScrollView.setContentOffset(.zero, animated: true)
        childScrollView?.setContentOffset(.zero, animated: true)
    }

    public func willDisplayChildScrollView(_ scrollView: UIScrollView?) {
        // 查找以前子类是否已经出现 并赋值以前状态
        if !childViews.contains(scrollView) {
            mainScrollView.eg_isCanScroll = true
            scrollView?.eg_isCanScroll = false
            childViews.append(scrollView)
        } else {
            if let view = childViews.first(where: { $0 == scrollView }), let subView = view {
                // 存在以前已经已经出现 滑动其他子类view 导致先前可滑动状态变化
                if subView.frame.height < subView.contentSize.height && mainScrollView.contentOffset.y == headerView.frame.height {
                    scrollView?.eg_isCanScroll = true
                    mainScrollView.eg_isCanScroll = false
                } else {
                    scrollView?.eg_isCanScroll = subView.eg_isCanScroll
                    mainScrollView.eg_isCanScroll = !subView.eg_isCanScroll
                }
            } else {
                mainScrollView.eg_isCanScroll = true
                scrollView?.eg_isCanScroll = false
            }
        }

        // 如果主视图滚动位置y小于头视图高度，说明头视图位置已经进入视线
        // 将子视图滚动位置归零
        if mainScrollView.contentOffset.y < headerView.frame.height - betweenHeight {
            scrollView?.contentOffset = .zero
            scrollView?.eg_isCanScroll = false
        }
    }

    public func didDisplayChildScrollView(_ scrollView: UIScrollView?) {
        childScrollView = scrollView
        setupChildScrollViewObservation()
    }
}

private extension NestedScrollManager {
    // 添加主视图滚动观察
    func setupMainScrollViewObservation() {
        mainScrollViewObservation = mainScrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self, change.newValue != change.oldValue else {
                return
            }
            self.mainScrollViewDidScroll(scrollView)
        })
    }

    // 添加子视图滚动观察
    func setupChildScrollViewObservation() {
        childScrollViewObservation = childScrollView?.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self, change.newValue != change.oldValue else {
                return
            }
            DispatchQueue.main.async {
                self.childScrollViewDidScroll(scrollView)
            }
        })

        // 监听子类contentSize 发生变化导致子类可以滑动
        childScrollViewContentObservation = childScrollView?.observe(\.contentSize, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self, change.newValue != change.oldValue else {
                return
            }
            self.childScrollViewContentChanged(scrollView)
        })
        guard let childScrollView = childScrollView else {
            return
        }
        childScrollViewContentChanged(childScrollView)
    }
}

private extension NestedScrollManager {
    func mainScrollViewDidScroll(_ scrollView: UIScrollView) {
        // 主视图不能滚动
        // 将主视图固定在头视图底部位置，就是segment在顶部
        // 设置子视图可以滚动
        if !scrollView.eg_isCanScroll {
            scrollView.contentOffset.y = headerView.frame.height - betweenHeight
            childScrollView?.eg_isCanScroll = true
            if let view = childViews.first(where: { $0 == scrollView }), let subView = view {
                subView.eg_isCanScroll = true
            }
        } else {
            // 主视图能滚动
            // 如果主视图滚动位置大于头视图
            // 将主视图固定在头视图底部位置，就是segment在顶部
            // 设置主视图不能滚动
            // 设置子视图可以滚动
            //
            // fixbug: 解决当子视图没有足够内容滚动时，整体滚动卡住的问题
            // childScrollView?.canScroll ?? false 当条件不成立时，不会设置主视图不可滚动
            if scrollView.contentOffset.y >= headerView.frame.height - betweenHeight && childScrollView?.canScroll ?? false {
                scrollView.contentOffset.y = headerView.frame.height - betweenHeight
                mainScrollView.eg_isCanScroll = false
                childScrollView?.eg_isCanScroll = true
                if let view = childViews.first(where: { $0 == scrollView }), let subView = view {
                    subView.eg_isCanScroll = true
                }
            }
        }
    }

    func childScrollViewDidScroll(_ scrollView: UIScrollView) {
        // 子视图不能滚动 且 (没有下拉刷新 或 主视图 y 滑动大于 0)
        // 将子视图固定到顶部
        if !scrollView.eg_isCanScroll && (scrollView.rf.header == nil || mainScrollView.contentOffset.y > 0) {
            scrollView.contentOffset.y = 0
        } else {
            // 子视图可以滚动
            // 如果子视图滚动到顶部
            // 设置子视图不可滚动
            // 设置主视图可以滚动
            if scrollView.contentOffset.y <= 0 {
                if let view = childViews.first(where: { $0 == scrollView }), let subView = view {
                    subView.eg_isCanScroll = false
                }
                scrollView.eg_isCanScroll = false
                mainScrollView.eg_isCanScroll = true
            }
        }
    }

    // 子视图置顶
    // 子视图内容发生变化可以滚动
    func childScrollViewContentChanged(_ scrollView: UIScrollView) {
        if !scrollView.eg_isCanScroll && mainScrollView.contentOffset.y == headerView.frame.height && scrollView.frame.height < scrollView.contentSize.height {
            mainScrollView.eg_isCanScroll = false
            scrollView.eg_isCanScroll = true

        }
    }
}

private var scrollViewkey = "eg_isCanScroll"

private extension UIScrollView {
    // 能否滚动
    var eg_isCanScroll: Bool {
        get {
            return withUnsafePointer(to: &scrollViewkey) { pointer in
                return (objc_getAssociatedObject(self, pointer) as? Bool) ?? false
            }
        }
        set {
            withUnsafePointer(to: &scrollViewkey) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    /// 判断一个滚动视图是否有足够的内容滚动
    var canScroll: Bool {
        return contentSize.height > frame.height
    }
}
