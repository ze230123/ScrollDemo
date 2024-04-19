//
//  GradientShadowButton.swift
//  YouYiKao
//
//  Created by Jason on 2022/6/16.
//

import UIKit

/// 阴影和圆角共存
@IBDesignable
public class GradientShadowButton: UIButton {
    /// 阴影颜色
    @IBInspectable public var shadowColor: UIColor?

    /// 阴影偏移
    @IBInspectable public var shadowOffet: CGSize = .zero

    /// 阴影透明度 默认 0
    @IBInspectable public var shadowOpacity: Float = 1

    /// 模糊半径
    @IBInspectable public var shadowRadius: CGFloat = 3.0

    @IBInspectable public var cornerRadius: CGFloat = 10

    @IBInspectable public var startColor: UIColor = UIColor(hex: 0xFF5053)
    @IBInspectable public var endColor: UIColor = UIColor(hex: 0xE9302D)

    @IBInspectable public var startPoint: CGPoint = CGPoint(x: 0, y: 0.5)
    @IBInspectable public var endPoint: CGPoint = CGPoint(x: 1, y: 1.5)

    @IBInspectable public var disabledStartColor: UIColor = UIColor(hex: 0xFBAAAA)
    @IBInspectable public var disabledEndColor: UIColor = UIColor(hex: 0xF29C9A)

    private lazy var gradientLayer = CAGradientLayer()

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

public extension GradientShadowButton {
    func display() {
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors.compactMap { $0 }
        gradientLayer.cornerRadius = cornerRadius
        if let shadowColor = shadowColor {
            gradientLayer.shadowColor = shadowColor.cgColor
            gradientLayer.shadowOffset = shadowOffet
            gradientLayer.shadowOpacity = shadowOpacity
            gradientLayer.shadowRadius = shadowRadius
        }
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

public extension GradientShadowButton {
    var colors: [CGColor] {
        if state == .disabled {
            return [disabledStartColor.cgColor, disabledEndColor.cgColor]
        } else {
            return [startColor.cgColor, endColor.cgColor]
        }
    }
}
