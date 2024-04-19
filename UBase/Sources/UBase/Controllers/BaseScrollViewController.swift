//
//  BaseScrollViewController.swift
//  
//
//  Created by 张泽群 on 2022/11/22.
//

import UIKit

open class BaseScrollViewController: BaseViewController {
    @IBOutlet open var scrollView: ScrollView!

    open override func viewDidLoad() {
        super.viewDidLoad()
        initScrollView()
    }
}

private extension BaseScrollViewController {
    func initScrollView() {
        if scrollView == nil {
            scrollView = ScrollView(frame: view.bounds)
            scrollView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
            view.addSubview(scrollView)
        }
    }
}
