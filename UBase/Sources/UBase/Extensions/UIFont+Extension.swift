//
//  UIFont+Extension.swift
//  YouZhiYuan
//
//  Created by youzy01 on 2019/8/20.
//  Copyright © 2019 泽i. All rights reserved.
//

import UIKit

public extension UIFont {
    /// 数字字体
    static func bebas(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Bebas", size: ofSize)!
    }

    /// PingFangSC-Medium 字体
    static func medium(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: ofSize)!
    }

    /// PingFangSC-Semibold 字体
    static func semibold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: ofSize)!
    }

    /// PingFangSC-Regular 字体
    static func regular(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: ofSize)!
    }
}
