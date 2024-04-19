//
//  CGSize+Extension.swift
//  YouZhiYuan
//
//  Created by 泽i on 2018/12/17.
//  Copyright © 2018 泽i. All rights reserved.
//

import UIKit

public extension CGSize {
    /// 坐标为零的 frame
    var rect: CGRect {
        return CGRect(origin: CGPoint.zero, size: self)
    }

    /// 中心为屏幕中心的frame
    var centerRect: CGRect {
        return CGRect(
            origin: CGPoint(
                x: (UIScreen.main.bounds.width - self.width) / 2.0,
                y: (UIScreen.main.bounds.height - self.height) / 2.0
            ),
            size: self)
    }
}
