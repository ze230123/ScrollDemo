//
//  BaseNestedViewController.swift
//  
//
//  Created by 张泽群 on 2022/10/9.
//

import UIKit

/// 可嵌套页面基类
///
/// 一个可滚动的页面如果可以分为几个不用复用单独的部分
/// 以及垂直方向上有两个以上的滚动视图并可以整体联动
/// 可以使用此基类
///
/// 使用NestedView实现，每个部分需遵守Nestedable协议
/// **Nestedable协议中的nestedVIew必须使用weak修饰**
///     `
///        weak var nestedView: NestedView?
///     `
///
open class BaseNestedViewController: BaseViewController {
    @IBOutlet open var nestedView: NestedView!

    open override func viewDidLoad() {
        super.viewDidLoad()
        initNestedView()
    }
}

private extension BaseNestedViewController {
    func initNestedView() {
        if nestedView == nil {
            nestedView = NestedView(frame: view.bounds)
            nestedView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
            view.addSubview(nestedView)
        }
    }
}
