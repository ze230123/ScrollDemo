//
//  CollectionDataSource.swift
//  YouZhiYuan
//
//  Created by youzy01 on 2020/8/18.
//  Copyright © 2020 泽i. All rights reserved.
//

import UIKit

/// UICollectionView的DataSource
///
/// **适用情况:**
///  * **没有headerView、footerView，且只有一种cell**
open class UCollectionDataSource<C: UICollectionViewCell, M>: NSObject, UICollectionViewDataSource where C: CellConfigurable, C.T == M {

    public var items: [M] {
        return dataSource
    }

    private(set) var dataSource: [M] = [] {
        didSet {
//            collectionView?.reloadData()
            didReloadData?()
        }
    }

    /// 数据是否为空
    public var isEmpty: Bool {
        return dataSource.isEmpty
    }

    public var count: Int {
        return dataSource.count
    }

    /// cell已经复用
    public var dequeueReusable: ((C, IndexPath) -> Void)?
    /// 已经刷新
    public var didReloadData: (() -> Void)?

    private(set) weak var collectionView: UICollectionView?

    public subscript(_ index: Int) -> M {
        get {
            return dataSource[index]
        }
        set {
            dataSource[index] = newValue
        }
    }

    public subscript(_ indexPath: IndexPath) -> M {
        get {
            return dataSource[indexPath.item]
        }
        set {
            dataSource[indexPath.item] = newValue
        }
    }

    public override init() {
        super.init()
    }

    required public init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        registerCell(collectionView: collectionView)
    }

    open func append(_ newElement: M) {
        dataSource.append(newElement)
    }

    open func append(contentsOf arr: [M]) {
        dataSource.append(contentsOf: arr)
    }

    open func set(contentsOf arr: [M]) {
        dataSource = arr
    }

    open func removeAll() {
        dataSource.removeAll()
    }

    open func remove(at index: Int) {
        dataSource.remove(at: index)
        collectionView?.reloadData()
    }

    open func firstIndex(where predicate: (M) throws -> Bool) rethrows -> Int? {
        return try dataSource.firstIndex(where: predicate)
    }

    open func registerCell(collectionView: UICollectionView?) {
        self.collectionView = collectionView
        collectionView?.registerCell(C.self)
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as C
        dequeueReusable?(cell, indexPath)
        cell.configure(item: dataSource[indexPath.item])
        return cell
    }
}
