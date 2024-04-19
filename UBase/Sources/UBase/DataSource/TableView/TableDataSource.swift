//
//  TableDataSource.swift
//  YouZhiYuan
//
//  Created by youzy01 on 2020/8/6.
//  Copyright © 2020 泽i. All rights reserved.
//

import UIKit

open class UTableDataSource<C: UITableViewCell, M>: NSObject, UITableViewDataSource where C: CellConfigurable, C.T == M {

    public var items: [M] {
        return dataSource
    }

    private(set) var dataSource: [M] = [] {
        didSet {
//            tableView?.reloadData()
        }
    }

    public var isEmpty: Bool {
        return dataSource.isEmpty
    }

    public var dequeueReusable: ((C, IndexPath, M) -> Void)?

    private(set) weak var tableView: UITableView?

    public subscript(_ index: Int) -> M {
        return dataSource[index]
    }

    public subscript(_ indexPath: IndexPath) -> M {
        return dataSource[indexPath.row]
    }

    public override init() {
        super.init()
    }

    required public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        registerCell(tableView: tableView)
    }

    open func append(_ newElement: M) {
        dataSource.append(newElement)
    }

    open func append(contentsOf arr: [M]) {
        dataSource.append(contentsOf: arr)
    }

    open func setItems(_ arr: [M]) {
        dataSource = arr
    }

    open func removeAll() {
        dataSource.removeAll()
    }

    open func remove(at index: Int) {
        dataSource.remove(at: index)
        tableView?.reloadData()
    }

    open func firstIndex(where predicate: (M) throws -> Bool) rethrows -> Int? {
        return try dataSource.firstIndex(where: predicate)
    }

    open func registerCell(tableView: UITableView?) {
        self.tableView = tableView
        tableView?.registerCell(C.self)
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as C
        let item = dataSource[indexPath.item]
        dequeueReusable?(cell, indexPath, item)
        cell.configure(item: item)
        return cell
    }
}
