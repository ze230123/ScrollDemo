//
//  CollectionView.swift
//  
//
//  Created by 张泽群 on 2022/10/12.
//

import UIKit

open class CollectionView: UICollectionView {
    /// 是否显示空数据提示, 默认true
    @IBInspectable public var isShowTips: Bool = true
    /// 空数据是否按照section模式判断
    @IBInspectable public var isEmptyForSection: Bool = false

    open override func reloadData() {
        super.reloadData()
        var isEmpty = (numberOfSections == 1 && numberOfItems(inSection: 0) == 0)
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
                NSLayoutConstraint.activate([
                    emptyView.topAnchor.constraint(equalTo: topAnchor),
                    emptyView.leftAnchor.constraint(equalTo: leftAnchor),
                    emptyView.widthAnchor.constraint(equalTo: widthAnchor),
                    emptyView.heightAnchor.constraint(equalTo: heightAnchor)
                ])
            }
        } else if !isEmpty, let emptyView = emptyView() {
            emptyView.removeFromSuperview()
        }
    }

    public var emptyAppearance: ListEmptyAppearance? = UBase.emptyAppearance

    func emptyView() -> UIView? {
        return subviews.first(where: { $0 is ListViewDataEmptyType })
    }
}
