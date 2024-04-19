//
//  NibLoadable.swift
//  
//
//  Created by youzy01 on 2020/9/28.
//

import UIKit

public protocol NibLoadable: AnyObject {
    func loadViewFromNib(name: String, bundle: Bundle) -> UIView
    func initViewFromNib(name: String, enabled: Bool, bundle: Bundle)
}

public extension NibLoadable where Self: UIView {

    func loadViewFromNib(name: String = "", bundle: Bundle) -> UIView {
        let className = type(of: self)

        var nibName: String = ""
        if !name.isEmpty {
            nibName = name
        } else {
            nibName = NSStringFromClass(className).components(separatedBy: ".").last ?? ""
        }
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first(where: { $0 is UIView }) as! UIView
        return view
    }

    func initViewFromNib(name: String = "", enabled: Bool = true, bundle: Bundle = .main) {
        let contentView = loadViewFromNib(name: name, bundle: bundle)
        contentView.isUserInteractionEnabled = enabled
        contentView.frame = bounds
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // 在协议里面不允许定义class 只能定义static
    static func loadFromNib(_ nibname: String? = nil) -> Self {// Self (大写) 当前类对象
        // self(小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first(where: { $0 is Self }) as! Self
    }
}
