//
//  GradientButtonView.swift
//  YouPlusApp
//
//  Created by youzy01 on 2019/9/5.
//  Copyright © 2019 youzy. All rights reserved.
//

import UIKit

/// 在View中的渐变按钮
@IBDesignable
open class GradientButtonView: UIView, NibLoadable {

    @IBOutlet public weak var button: GradientButton!

    @IBInspectable public var title: String = "" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    @IBInspectable public var isEnabled: Bool = true {
        didSet {
            button.isEnabled = isEnabled
        }
    }

    public init(title: String? = nil, target: Any?, action: Selector) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 74))
        initViewFromNib(bundle: .module)
        button.addTarget(target, action: action, for: .touchUpInside)
        if let title = title {
            button.setTitle(title, for: .normal)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib(bundle: .module)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib(bundle: .module)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        button.cornerRadius = (bounds.height - 30) / 2
        button.masksToBounds = true
    }

    public func addTarget(_ target: Any, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}
