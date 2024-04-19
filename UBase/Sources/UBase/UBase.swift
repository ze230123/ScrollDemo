//
//  UBase.swift
//  
//
//  Created by 张泽群 on 2023/8/23.
//

import UIKit

/// 图片下载器
public var downloader: RemoteImageDownloader!
/// 列表空视图样式
public var emptyAppearance: ListEmptyAppearance?

/// 初始化模块，设置模块里必要的属性
public func initialize(downloader: RemoteImageDownloader, emptyAppearance: ListEmptyAppearance?) {
    UBase.downloader = downloader
    UBase.emptyAppearance = emptyAppearance
}

struct Screen {
    static let width = UIScreen.main.bounds.width
}
