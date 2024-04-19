//
//  ViewController.swift
//  ScrollDemo
//
//  Created by youzy on 2024/4/18.
//

import UIKit
import UBase

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: ScrollView!
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var pageView: UIScrollView!

    @IBOutlet weak var listView: UIScrollView!

    @IBOutlet weak var collectionView: UICollectionView!

    lazy var manager = NestedScrollManager(mainScrollView: scrollView, headerView: headerView, ignoreGestureViews: [pageView])

    override func viewDidLoad() {
        super.viewDidLoad()

        pageView.contentOffset = CGPoint(x: view.bounds.width, y: 0)

        manager.willDisplayChildScrollView(listView)
        manager.didDisplayChildScrollView(listView)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! LabelCell
        cell.label.text = "\(indexPath.item)"
        return cell
    }
}

class LabelCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}
