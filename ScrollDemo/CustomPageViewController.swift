//
//  CustomPageViewController.swift
//  ScrollDemo
//
//  Created by youzy on 2024/4/19.
//

import UIKit
import UBase
import UWidget

class CustomPageViewController: BaseViewController {
    @IBOutlet weak var scrollView: ScrollView!

    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var segment: EGScrollSegment!

    @IBOutlet weak var collectionView: UICollectionView!

    lazy var manager = NestedScrollManager(mainScrollView: scrollView, headerView: headerView, ignoreGestureViews: [])

    var dataSource: [ChildScrolable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = (0...5).map { ScrollViewController.make(index: $0) }

        let title = dataSource.indices.map { "第 \($0) 个" }

        segment.addItems(title)
    }

    @IBAction func segmentDidChange() {
        let indexPath = IndexPath(item: segment.selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

extension CustomPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellID", for: indexPath)
        debugPrint("cellFor item ", indexPath.item)
        cell.backgroundColor = UIColor.random
        return cell
    }
}

extension CustomPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        debugPrint("willDisplay", indexPath.item)
        let vc = dataSource[indexPath.item]
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        cell.contentView.addSubview(vc.view)
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            vc.view.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
            vc.view.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
            vc.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        vc.didMove(toParent: self)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        debugPrint("didEndDisplaying", indexPath.item)
        let vc = dataSource[indexPath.item]
        vc.willMove(toParent: self)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}

extension CustomPageViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / view.frame.width)
        let vc = dataSource[page]
        segment.selectedIndex = page
        manager.willDisplayChildScrollView(vc.childScrollView)
        manager.didDisplayChildScrollView(vc.childScrollView)
    }
}

class CustomPageLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView else {
            return
        }
        scrollDirection = .horizontal
        itemSize = collectionView.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
