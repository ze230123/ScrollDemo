//
//  Int+Extension.swift
//  YouZhiYuan
//
//  Created by 泽i on 2018/9/5.
//  Copyright © 2018年 泽i. All rights reserved.
//

import Foundation

public extension Int {
    /// 毫秒 to 秒
    var milliToSecond: TimeInterval {
        return TimeInterval(self / 1000)
    }

    /// 数字转为字符串
    var timeValue: String {
        guard self >= 10 else {
            return "0\(self)"
        }
        return "\(self)"
    }

    /// 将0 转为 `-`
    var invalid: String {
        guard self == 0 else {
            return "\(self)"
        }
        return "-"
    }

    /// 将 0 转换为 空字符串
    var strValue: String {
        guard self == 0 else {
            return "\(self)"
        }
        return ""
    }

    /// 将 0 转换为 false
    var boolValue: Bool {
        guard self == 1 else {
            return false
        }
        return true
    }

    /// int 值转换字符串 0 还是"0"
    var stringValue: String {
        return "\(self)"
    }

    /// 人民币单位元转换为分
    var cents: Int {
        return self * 100
    }

    /// 千位的值
    var thousandsValue: Int {
        return self / 1000
    }

    /// 百位的值
    var hundredsValue: Int {
        return self / 100 % 10
    }

    /// 十位的值
    var tenValue: Int {
        return self / 10 % 10
    }

    /// 个位的值
    var singleValue: Int {
        return self % 10
    }

    var doudleValue: Double {
        return Double(self)
    }
}

// 34643.toWan() -> 3.5万
public extension Int {
    func toWan() -> String {
        if self < 10000 {
            return "\(self)"
        } else {
            return "\((Double(self) / Double(10000)).roundTo(places: 1))万"
        }
    }
}

public extension Int {
    var floatValue: CGFloat {
        return CGFloat(self)
    }

    var numberValue: NSNumber {
        return NSNumber(value: self)
    }
}

public extension Optional where Wrapped == Int {
    /// 可选无效值显示`-`
    /// 无效值包括: `0`、`""`
    var optionInvalid: String {
        guard let int = self else {
            return "-"
        }
        return int.invalid
    }

    /// 可选默认显示`0`
    var optionEmpty: Int {
        guard let text = self else {
            return 0
        }
        return text
    }
}
