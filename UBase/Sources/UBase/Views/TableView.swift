//
//  TableView.swift
//  YouZhiYuan
//
//  Created by peng guo on 2022/10/9.
//  Copyright © 2022 泽i. All rights reserved.
//

import UIKit

/// 定制UITableView，支持空数据提示
open class TableView: UITableView {
    /// 是否显示空数据提示, 默认true
    @IBInspectable public var isShowTips: Bool = true
    /// 是否更新空数据提示，默认false 不更新
    @IBInspectable public var isUpdateTips: Bool = false
    /// 显示控制图时是否展示`TableHeaderView`, 默认：false 不展示
    @IBInspectable public var isShowTableHeaderViewForEmpty: Bool = false
    /// 显示控制图时是否展示`SectionHeaderView`, 默认：false 不展示
    @IBInspectable public var isShowSectionHeaderViewForEmpty: Bool = false
    /// 空数据是否按照section模式判断
    @IBInspectable public var isEmptyForSection: Bool = false

    open override func reloadData() {
        super.reloadData()
        debugPrint("emptyAppearance", emptyAppearance as Any)
        var isEmpty = (numberOfSections == 1 && numberOfRows(inSection: 0) == 0)
        if isEmptyForSection {
            isEmpty = numberOfSections == 0
        }
        // 判断是否已经显示空视图
        let isShowEmpty = subviews.contains(where: { $0 is ListViewDataEmptyType })
        // 没有显示空视图才会去添加
        if isShowTips && isEmpty && !isShowEmpty, let emptyClass = emptyAppearance?.emptyViewType {
            if let emptyView = emptyClass.init(appearance: emptyAppearance) {
                emptyView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(emptyView)
                var top: CGFloat = 0
                if isShowTableHeaderViewForEmpty {
                    top = tableHeaderView?.frame.maxY ?? 0
                }
                if isShowSectionHeaderViewForEmpty {
                    top += sectionHeaderHeight
                }
                NSLayoutConstraint.activate([
                    emptyView.topAnchor.constraint(equalTo: topAnchor, constant: top),
                    emptyView.leftAnchor.constraint(equalTo: leftAnchor),
                    emptyView.widthAnchor.constraint(equalTo: widthAnchor),
                    emptyView.heightAnchor.constraint(equalTo: heightAnchor)
                ])
            }
        } else if !isEmpty, let emptyView = emptyView() {
            emptyView.removeFromSuperview()
        } else if isUpdateTips, let emptyView = emptyView() {
            emptyView.update(appearance: emptyAppearance)
        }
    }

    public var emptyAppearance: ListEmptyAppearance? = UBase.emptyAppearance

    public func removeEmptyView() {
        emptyView()?.removeFromSuperview()
    }

    func emptyView() -> ListViewDataEmptyType? {
        return subviews.first(where: { $0 is ListViewDataEmptyType }) as? ListViewDataEmptyType
    }
}

