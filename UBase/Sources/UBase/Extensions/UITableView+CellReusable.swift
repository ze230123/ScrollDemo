//
//  File.swift
//  
//
//  Created by youzy01 on 2020/9/28.
//

import UIKit

public extension UITableView {
    /// 注册cell
    func registerCell<C: UITableViewCell>(_ cell: C.Type) where C: CellReusable {
        if let nib = C.nib {
            register(nib, forCellReuseIdentifier: C.reuseableIdentifier)
        } else {
            register(cell, forCellReuseIdentifier: C.reuseableIdentifier)
        }
    }

    /// 注册section
    func registerSection<H: UIView>(_ header: H.Type) where H: CellConfigurable {
        if let nib = header.nib {
            register(nib, forHeaderFooterViewReuseIdentifier: H.reuseableIdentifier)
        } else {
            register(header, forHeaderFooterViewReuseIdentifier: H.reuseableIdentifier)
        }
    }

    /// 复用cell
    func dequeReusableCell<C: UITableViewCell>(indexPath: IndexPath) -> C where C: CellReusable {
        // swiftlint:disable force_cast
        return dequeueReusableCell(withIdentifier: C.reuseableIdentifier, for: indexPath) as! C
    }

    /// 复用section
    func dequeReusableHeaderFooter<H: UIView>() -> H? where H: CellConfigurable {
        return dequeueReusableHeaderFooterView(withIdentifier: H.reuseableIdentifier) as? H
    }

    /// 获取cell
    func cellForRow<C>(at indexPath: IndexPath) -> C? where C: CellConfigurable {
        return self.cellForRow(at: indexPath) as? C
    }
}
