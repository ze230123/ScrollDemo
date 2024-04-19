//
//  Double+Extension.swift
//  YouZhiYuan
//
//  Created by 泽i on 2019/3/28.
//  Copyright © 2019 泽i. All rights reserved.
//

import UIKit

public extension Double {
    var intValue: Int {
        return Int(self)
    }
}

public extension Double {
    /// 保留几位四舍五入
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    /// 人民币单位元转换为分
    var cents: Int {
        return Int(self * 100)
    }

    /// 将0、0.0 转为 `-`
    var probabilityValid: String {
        guard self == 0 || self == 0.0 else {
            return "\(self)"
        }
        return "-"
    }
}
