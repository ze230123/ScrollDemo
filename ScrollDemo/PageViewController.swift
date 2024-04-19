//
//  PageViewController.swift
//  ScrollDemo
//
//  Created by youzy on 2024/4/19.
//

import UIKit
import UBase
import UWidget

class PageViewController: BaseViewController {
    @IBOutlet weak var scrollView: ScrollView!
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var contentView: UIView!

    let pageManager = PageManager()

    lazy var pageController = PageController(manager: pageManager)

    lazy var manager = NestedScrollManager(mainScrollView: scrollView, headerView: headerView, ignoreGestureViews: [pageController.scrollView])

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController.view.frame = contentView.bounds
        pageController.view.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        contentView.addSubview(pageController.view)
        addChild(pageController)

        pageManager.willDisplayController = { [weak manager] (_, view, _) in
            manager?.willDisplayChildScrollView(view.childScrollView)
        }

        pageManager.didDisplayController = { [weak manager] (_, view, _) in
            manager?.didDisplayChildScrollView(view.childScrollView)
        }

        pageManager.vcArr = (0...5).map { ScrollViewController.make(index: $0) }

        pageManager.scroll(to: 0)
    }
}
