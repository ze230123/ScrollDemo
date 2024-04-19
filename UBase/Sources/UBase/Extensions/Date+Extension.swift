//
//  Date+Extension.swift
//  YouZhiYuan
//
//  Created by 泽i on 2020/2/19.
//  Copyright © 2020 泽i. All rights reserved.
//

import Foundation

public extension Date {
    /// 是今年
    var isThisYear: Bool {
        let calendar = Calendar.current

        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        return nowCmps.year == selfCmps.year
    }

    /// 是今天
    var isToday: Bool {
        let calendar = Calendar.current

        let nowCmps = calendar.dateComponents([.day], from: Date())
        let selfCmps = calendar.dateComponents([.day], from: self)
        return nowCmps.day == selfCmps.day
    }
}

public extension Date {
    /// 高考完成时间已经不做参考，目前只用于智能填报排序年使用
    static var isGaokaoFinish: Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: Date())
        let month = components.month ?? 0
        if month >= 9 {
            return true
        }
        return false
    }

    static var currentYear: Int {
        let calendar = Calendar.current
        let components = calendar.component(.year, from: Date())
        return components
    }

    /// 填报排序年
    static var smartFillYear: Int {
        var year = Date.currentYear
        if Date.isGaokaoFinish {
            year += 1
        }
        return year
    }
}
