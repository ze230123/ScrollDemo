//
//  Bool+Extension.swift
//  YouZhiYuan
//
//  Created by Jason on 2020/4/10.
//  Copyright © 2020 泽i. All rights reserved.
//

import UIKit

public extension Bool {
    /// 将false 转为 0， true 为1
    var valid: Int {
        guard self == true else {
            return 0
        }
        return 1
    }
}

public extension Optional where Wrapped == Bool {
    /// 可选为空默认true
    var optionTrue: Bool {
        guard let isSome = self else {
            return true
        }
        return isSome
    }

    /// 可选为空默认为false
    var optionFalse: Bool {
        guard let isSome = self else {
            return false
        }
        return isSome
    }
}
