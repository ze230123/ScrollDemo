//
//  BaseViewController.swift
//  
//
//  Created by youzy01 on 2020/9/17.
//

import UIKit
import RxSwift

open class BaseViewController: UIViewController, ErrorHandler {
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
