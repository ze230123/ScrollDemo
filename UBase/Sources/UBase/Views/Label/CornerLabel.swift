//
//  CornerLabel.swift
//  
//
//  Created by dev-02 on 2020/12/28.
//

import UIKit

@IBDesignable
public class CornerLabel: UILabel {

    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable public var masksToBounds: Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
}
