//
//  File.swift
//  
//
//  Created by 张泽群 on 2022/10/13.
//

import UIKit

public protocol ErrorViewType: UIView {
    func showError(_ error: Error, handler: @escaping () -> Void)
}
