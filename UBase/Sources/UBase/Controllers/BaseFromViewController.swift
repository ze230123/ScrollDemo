//
//  BaseFromViewController.swift
//  
//
//  Created by youzy01 on 2021/1/7.
//

import UIKit
import Eureka
import RxSwift

open class BaseFromViewController: FormViewController, ErrorHandler {
    public let disposeBag = DisposeBag()

    open override var shouldAutorotate: Bool {
        return false
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    deinit {
        UHUD.hide(for: view)
        debugPrint("\(type(of: self))_deinit")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9607843137, blue: 0.9568627451, alpha: 1)
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }

    /// 网络请求、子类重写
    open func request() {
    }

    open func onReTry() {
        request()
    }

    @IBAction open func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
