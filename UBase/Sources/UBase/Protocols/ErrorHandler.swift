//
//  File.swift
//  
//
//  Created by 张泽群 on 2022/10/13.
//

import Foundation

public protocol ErrorHandler: AnyObject {
    func onReTry()
}
