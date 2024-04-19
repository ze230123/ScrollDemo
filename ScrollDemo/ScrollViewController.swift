//
//  ScrollViewController.swift
//  ScrollDemo
//
//  Created by youzy on 2024/4/19.
//

import UIKit
import UBase
import UWidget

class ScrollViewController: BaseViewController, ChildScrolable {
    var childScrollView: UIScrollView? {
        return scrollView
    }

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var label: UILabel!

    var index: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.random
        label.text = "\(index)"
        debugPrint("viewDidLoad", index)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("viewWillAppear", index)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("viewDidAppear", index)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("viewWillDisappear", index)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("viewDidDisappear", index)
    }
}

extension ScrollViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! LabelCell
        cell.label.text = "\(indexPath.item)"
        return cell
    }
}

extension ScrollViewController {
    static func make(index: Int) -> ScrollViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScrollVC") as! ScrollViewController
        vc.index = index
        return vc
    }
}
