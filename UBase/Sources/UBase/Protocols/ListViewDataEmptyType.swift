//
//  ListViewDataEmptyType.swift
//  
//
//  Created by 张泽群 on 2022/10/11.
//

import UIKit

/// 列表空数据协议
public protocol ListViewDataEmptyType: UIView {
    init?(appearance: ListEmptyAppearance?)
    func update(appearance: ListEmptyAppearance?)
}

public struct ListEmptyAppearance {
    public typealias EventHandler = () -> Event?

    /// 空数据文字
    public var text: String?

    /// 空数据详细
    public var detailText: String?

    /// 空数据图片
    public var image: UIImage?

    /// 空数据视图按钮事件响应
    ///
    /// 按钮标题事件响应, 默认为nil
    public var buttonEvent: EventHandler?

    public var emptyViewType: ListViewDataEmptyType.Type?

    public init() {}

    /// 事件响应
    public struct Event {
        /// 空数据按钮标题
        public var title: String?
        /// 空数据按钮图片
        public var image: UIImage?
        /// 点击事件Target
        public var target: Any?
        /// 点击事件响应方法
        public var action: Selector

        public init(title: String?, target: Any?, action: Selector) {
            self.title = title
            self.target = target
            self.action = action
        }
    }
}
