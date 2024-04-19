//
//  TextField.swift
//  YouYiKao
//
//  Created by Jason on 2022/3/30.
//

import UIKit

@IBDesignable
public class TextField: UITextField {

    /// 占位字体
    @IBInspectable public var placeholderFont: CGFloat = 14 {
        didSet {
            setNeedsDisplay()
        }
    }

    /// 占位颜色
    @IBInspectable public var placeholderColor: UIColor = UIColor(hex: 0x999999) {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func drawPlaceholder(in rect: CGRect) {
        let font = UIFont(name: "PingFangSC-Regular", size: placeholderFont)!
        let size = ((placeholder ?? "") as NSString).size(withAttributes: [.font: font])
        let frame = CGRect(x: 2, y: (rect.size.height - size.height) / 2, width: size.width, height: size.height)
        placeholder?.draw(in: frame, withAttributes: [.font: font, .foregroundColor: placeholderColor])
    }

}
