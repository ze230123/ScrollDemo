//
//  EnabledButton.swift
//  YouYiKao
//
//  Created by Jason on 2022/4/1.
//

import UIKit

@IBDesignable
open class EnabledButton: UIButton {

    @IBInspectable public var enabledColor: UIColor = UIColor(hex: 0xE9302D)
    @IBInspectable public var unEnabledColor: UIColor = UIColor(hex: 0xE9302D, alpha: 0.2)

    @IBInspectable public var isAvailable: Bool = true {
        didSet {
            backgroundColor = isAvailable ? enabledColor : unEnabledColor
            isEnabled = isAvailable
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
