//
//  TabBar.swift
//  
//
//  Created by 张泽群 on 2022/11/15.
//

import UIKit

/// 自定义Tabbar
///
/// 在Tabbar上加了一层View，来实现按钮样式自定义。
/// 如果要添加活动按钮，请务必保持其他的按钮数量可以整除2。
/// 最多添加5个按钮，否则影响效果。
public class TabBar: UITabBar {
    private let contentView = UIView()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 4
        return view
    }()

    public override var barTintColor: UIColor? {
        didSet {
            contentView.backgroundColor = barTintColor
        }
    }

    public var selectedColor: UIColor? = .red
    public var unselectedColor: UIColor? = .blue

    /// TabbarButton选中处理
    public var selectedHandler: ((Int) -> Void)?

    public var selectedButton: TabBarButton? {
        didSet {
            guard oldValue?.item != selectedButton?.item else {
                selectedButton?.item.repeatClickHandler?()
                return
            }

            if let oldItem = oldValue?.item {
                oldValue?.titleLabel.text = oldItem.title
                oldValue?.titleLabel.textColor = unselectedColor
                oldValue?.imageView.load(url: oldItem.image, speed: oldItem.speed, loopMode: oldItem.loopMode)
            }

            if let currentItem = selectedButton?.item, let index = uItems.firstIndex(of: currentItem) {
                selectedButton?.titleLabel.textColor = selectedColor
                selectedButton?.imageView.load(url: currentItem.selectedImage, speed: currentItem.selectedSpeed, loopMode: currentItem.selectedLoopMode)
                selectedHandler?(index)
            }
        }
    }

    /// Tabbar自定义按钮数据
    public var uItems: [TabBarItem] = [] {
        didSet {
            initStackView()
            let btns = uItems.map(creatButton(for:))
            btns.forEach { stackView.addArrangedSubview($0) }
            if let first = btns.first {
                selectedButton = first
            }
            buttons = btns
        }
    }

    private var buttons: [TabBarButton] = []

    public func selectButton(at index: Int) {
        guard !buttons.isEmpty, buttons.count > index else {
            return
        }

        selectedButton = buttons[index]
    }

    /// 添加活动按钮
    ///
    /// 活动按钮默认添加在中间位置
    public func addActivity(item: TabBarItem, target: Any?, action: Selector) {
        let button = TabBarButton(item: item)
        button.titleLabel.text = item.title
        button.titleLabel.textColor = unselectedColor
        button.imageView.load(url: item.image, speed: item.speed, loopMode: item.loopMode)
        button.titleLabel.isHidden = item.isBigIcon
        button.addTarget(target, action: action, for: .touchUpInside)

        let count = stackView.arrangedSubviews.count
        let index = count / 2
        stackView.insertArrangedSubview(button, at: index)
    }

    /// 获取当前显示的标题
    ///
    /// index 为NSNotFound时，获取选中的button
    public func titleForIndex(at index: Int) -> String? {
        if index == NSNotFound, let currentButton = selectedButton {
            return currentButton.titleLabel.text
        }
        guard index < buttons.count else {
            return nil
        }
        let currentButton = buttons[index]
        return currentButton.titleLabel.text
    }

    /// 设置临时标题
    ///
    /// index 为NSNotFound时，设置选中的button
    public func setTitle(_ title: String, at index: Int) {
        guard buttons.indices.contains(index) else {
            return
        }
        let currentButton = buttons[index]
        currentButton.titleLabel.text = title
    }

    /// 设置临时图片
    ///
    /// index 为NSNotFound时，设置选中的button
    public func setImage(_ imageUrl: String, speed: CGFloat, loopMode: AnimateLoopMode, at index: Int) {
        guard buttons.indices.contains(index) else {
            return
        }
        let currentButton = buttons[index]
        currentButton.imageView.load(url: imageUrl, speed: speed, loopMode: loopMode)
    }

    public func removeAll() {
        let subViews = stackView.arrangedSubviews
        subViews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    // MARK: - 重写hitTest方法，监听按钮的点击 让凸出tabbar的部分响应点击
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden else {
            return super.hitTest(point, with: event)
        }
        if let views = stackView.arrangedSubviews as? [TabBarButton] {
            for view in views {
                let onImage = convert(point, to: view.imageView)
                if view.imageView.point(inside: onImage, with: event) {
                    return view
                }
            }
        }
        return super.hitTest(point, with: event)
    }
}

private extension TabBar {
    func initStackView() {
        contentView.backgroundColor = barTintColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func creatButton(for item: TabBarItem) -> TabBarButton {
        let button = TabBarButton(item: item)
        if !item.isBigIcon {
            button.titleLabel.text = item.title
            button.titleLabel.textColor = unselectedColor
        }
        button.imageView.load(url: item.image, speed: item.speed, loopMode: item.loopMode)
        button.addTarget(self, action: #selector(tapAction(sender:)), for: .touchUpInside)
        return button
    }

    @objc func tapAction(sender: TabBarButton) {
        selectedButton = sender
    }
}

