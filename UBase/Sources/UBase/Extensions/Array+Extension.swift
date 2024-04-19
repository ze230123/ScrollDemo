//
//  Array+Extension.swift
//  YouZhiYuan
//
//  Created by Jason on 2020/4/13.
//  Copyright © 2020 泽i. All rights reserved.
//

import UIKit

public extension Array where Element: Hashable {
    /// 有序去重
    var orderUnique: [Element] {
        var keys: [Element: ()] = [:]
        return filter { keys.updateValue((), forKey: $0) == nil }
    }
}

public extension Array {
    /// 数组不为空
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
