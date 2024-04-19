//
//  Refreshable.swift
//  
//
//  Created by youzy01 on 2020/9/17.
//

import UIKit
import Refresh

// MARK: - RF扩展
public extension RF {
    /// 开始刷新(只是header会开始刷新)
    func beginRefresh() {
        header?.beginRefresh()
    }

    func endRefresh(action: RefreshAction, isNotData: Bool) {
        switch action {
        case .load:
            header?.endRefresh()
            footer?.resetRefresh()
            footer?.isHidden = isNotData
        case .more:
            if isNotData {
                footer?.endRefreshNoMoreData()
            } else {
                footer?.endRefresh()
            }
        }
    }

    func endRefresh(action: RefreshAction, error: Error) {
        switch action {
        case .load:
            header?.endRefresh(error: error)
        case .more:
            footer?.endRefresh(error: error)
        }
    }
}

public protocol Refreshable: AnyObject {
    var pageIndex: Int { get set }
    func loadData()
    func moreData()
    func beginRefresh()
}

public extension Refreshable where Self: BaseTableViewController {
    func addRefreshHeader() {
        let headerView = RefreshHeaderView()
        headerView.tintColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        let header = RefreshHeader(view: headerView) { [weak self] in
            self?.loadData()
        }
        tableView.rf.header = header
    }

    func addRefreshFooter() {
        let footerView = RefreshFooterView { [weak self] in
            self?.onReTry()
        }
        footerView.tintColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        let footer = RefreshFooter(view: footerView) { [weak self] in
            self?.moreData()
        }
        footer.isHidden = true
        tableView.rf.footer = footer
    }

    func loadData() {
        pageIndex = 1
        willRequest(action: .load)
    }

    func moreData() {
        pageIndex += 1
        willRequest(action: .more)
    }

    func beginRefresh() {
        tableView.rf.beginRefresh()
    }
}

public extension Refreshable where Self: BaseCollectionViewController {
    func addRefreshHeader() {
        let headerView = RefreshHeaderView()
        headerView.tintColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        let header = RefreshHeader(view: headerView) { [weak self] in
            self?.loadData()
        }
        collectionView.rf.header = header
    }

    func addRefreshFooter() {
        let footerView = RefreshFooterView { [weak self] in
            self?.onReTry()
        }
        footerView.tintColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        let footer = RefreshFooter(view: footerView) { [weak self] in
            self?.moreData()
        }
        footer.isHidden = true
        collectionView.rf.footer = footer
    }

    func loadData() {
        pageIndex = 1
        willRequest(action: .load)
    }

    func moreData() {
        pageIndex += 1
        willRequest(action: .more)
    }

    func beginRefresh() {
        collectionView.rf.beginRefresh()
    }
}
