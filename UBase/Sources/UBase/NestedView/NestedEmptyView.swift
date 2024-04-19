//
//  NestedEmptyView.swift
//  
//
//  Created by youzy on 2023/12/11.
//

import UIKit

public class NestedEmptyView: UIView, Nestedable {
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: Screen.width, height: height)
    }

    public var contentOffset: CGPoint = .zero

    weak public var superNestedView: UBase.NestedView?

    private let height: CGFloat

    public init(height: CGFloat = 20, backgroundColor: UIColor = .white) {
        self.height = height
        super.init(frame: CGRect(x: 0, y: 0, width: Screen.width, height: height))
        self.backgroundColor = backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
