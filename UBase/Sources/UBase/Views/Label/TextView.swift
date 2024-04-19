//
//  TextView.swift
//  YouPlusApp
//
//  Created by youzy01 on 2019/10/30.
//  Copyright © 2019 youzy. All rights reserved.
//

import UIKit

@IBDesignable
public class TextView: UITextView {
    @IBInspectable public var placeholder: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var placeholderColor: UIColor = UIColor(hex: 0xC4C4C6) {
        didSet {
            setNeedsDisplay()
        }
    }

    public override var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }

    public override var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }

    public override var attributedText: NSAttributedString! {
        didSet {
            setNeedsDisplay()
        }
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addObserver()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObserver()
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }

    @objc func textDidChange() {
        setNeedsDisplay()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public override func draw(_ rect: CGRect) {
        guard !hasText else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        let att: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: placeholderColor,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        var new = rect
        new.origin.x = 5
        new.origin.y = 8
        new.size.width -= 10
        placeholder.draw(in: new, withAttributes: att)
    }
}

extension String {
    func draw(in rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]?) {
        NSString(string: self).draw(in: rect, withAttributes: attributes)
    }
}
