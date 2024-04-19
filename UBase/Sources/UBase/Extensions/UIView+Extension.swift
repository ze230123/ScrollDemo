//
//  UIView+Extension.swift
//  YouZhiYuan
//
//  Created by 泽i on 2018/12/24.
//  Copyright © 2018 泽i. All rights reserved.
//

import UIKit

public extension UIView {
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat, rect: CGRect = CGRect.zero) {
        guard corners != .allCorners else {
            layer.cornerRadius = radii
            layer.masksToBounds = true
            return
        }
        let frame = rect == .zero ? bounds : rect
        let maskPath = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    // 将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

public extension UIView {

    /// 设置阴影（需要圆角则不能使用masksToBounds）。
    func setShadow(_ shadowRadius: CGFloat = 3, color: UIColor = UIColor.black, radius: CGFloat = 5, shadowOpacity: Float = 0.5) {
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }

    func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }
}
