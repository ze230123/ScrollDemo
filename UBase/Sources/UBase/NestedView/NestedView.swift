//
//  NestedView.swift
//  
//
//  Created by 张泽群 on 2022/2/24.
//

import UIKit

private extension Array where Element == Nestedable {
    func isLastElement(_ element: Element) -> Bool {
        let boolValue = last?.contentView == element.contentView
        return boolValue
    }
}

/// 嵌套视图
///
/// 可将多个view、scrollview垂直排列，并管理所有视图的滚动
///
/// 遵守`Nestedable`协议的可以使`UIView`、`NSObject`、`UIViewController`
/// `UIViewController`可以实现一个列表的所有逻辑，只是将其`view`添加到`NestedView`中管理其滚动
public final class NestedView: UIScrollView {
    private lazy var contentView = UIView()

    private var subviewsInLayoutOrder: [Nestedable] = []

    deinit {
        debugPrint("EGStackView_deinit")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = bounds
        contentView.bounds = CGRect(origin: contentOffset, size: contentView.bounds.size)

        // 整体内容高度
        var offsetyOfCurrentSubview: CGFloat = 0

        for obj in subviewsInLayoutOrder {
            var subFrame = obj.frame
            if obj.isHidden {
                // 不要将高度设置为零。 只是不要将原始高度添加到 yOffsetOfCurrentSubview。
                // 这是为了在视图未隐藏时保持原来的高度。
                var frame = obj.frame
                frame.origin.y = offsetyOfCurrentSubview
                frame.origin.x = 0
                frame.size.width = self.contentView.bounds.size.width
                obj.frame = frame
                continue
            }

            // 如果是滚动视图
            if obj.isScroll {
                var subContentOffset = obj.contentOffset
                // 此处添加safeAreaInsets.top只是为了保持滚动视图有悬停view可以悬停在导航栏下
                if contentOffset.y + safeAreaInsets.top < offsetyOfCurrentSubview {
                    subContentOffset.y = 0
                    subFrame.origin.y = offsetyOfCurrentSubview
                } else {
                    subContentOffset.y = contentOffset.y + safeAreaInsets.top - offsetyOfCurrentSubview
                    subFrame.origin.y = contentOffset.y + safeAreaInsets.top
                }

                let normalHeight = obj.intrinsicContentSize.height
                let remainingBoundsHeight = fmax(bounds.maxY - subFrame.minY, normalHeight)
                let remainingContentHeight = fmax(obj.contentSize.height - subContentOffset.y, normalHeight)

                // 如果最后一个视图是滚动视图
                // 则设置滚动视图的高度为一个固定的高度，保证滚动视图不会随着滑动而整体上滑，
                // 此处的操作可以使上拉加载使用在滚动视图中而不是需要NestedView实现上拉加载
                if subviewsInLayoutOrder.isLastElement(obj) {
                    subFrame.size.height = remainingBoundsHeight
                } else {
                    subFrame.size.height = fmin(remainingBoundsHeight, remainingContentHeight)
                }

                subFrame.size.width = contentView.bounds.width

                obj.frame = subFrame
                obj.contentOffset = subContentOffset

                offsetyOfCurrentSubview += (fmax(obj.contentSize.height, obj.intrinsicContentSize.height) + obj.contentInset.top + obj.contentInset.bottom)
            } else {
                subFrame.origin.y = offsetyOfCurrentSubview
                subFrame.origin.x = 0
                subFrame.size.width = contentView.bounds.width
                subFrame.size.height = obj.intrinsicContentSize.height
                obj.frame = subFrame

                offsetyOfCurrentSubview += subFrame.size.height
            }
        }

//        let minimumContentHeight = bounds.size.height - (contentInset.top + contentInset.bottom)
        let initialContentOffset = contentOffset
        contentSize = CGSize(width: bounds.width, height: offsetyOfCurrentSubview)

        if initialContentOffset != contentOffset {
            setNeedsLayout()
        }
    }
}

public extension NestedView {
    func addArrangedSubview<Object>(_ obj: Object) where Object: Nestedable {
        obj.superNestedView = self
        contentView.addSubview(obj.contentView)
        subviewsInLayoutOrder.append(obj)
    }

    func removeArrangedView<Object>(_ obj: Object) where Object: Nestedable {
        obj.contentView.removeFromSuperview()
        subviewsInLayoutOrder.removeAll(where: { $0.contentView == obj.contentView })
        reload()
    }

    func removeAllArrangedViews() {
        subviewsInLayoutOrder.forEach { obj in
            obj.contentView.removeFromSuperview()
        }
        subviewsInLayoutOrder.removeAll()
        reload()
    }

    func scrollToView<Object>(_ obj: Object, animated: Bool) where Object: Nestedable {
        var y: CGFloat = 0
        for subObj in subviewsInLayoutOrder {
            if obj.contentView == subObj.contentView {
                break
            }
            if subObj.isHidden {
                continue
            }
            if subObj.isScroll {
                y += subObj.contentSize.height
            } else {
                y += subObj.frame.height
            }
        }
        y -= safeAreaInsets.top
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }

    func reload() {
        setNeedsLayout()
    }
}

private extension NestedView {
    func prepare() {
        addSubview(contentView)
    }
}
