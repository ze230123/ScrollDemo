//
//  RemoteImageDownloader.swift
//  
//
//  Created by 张泽群 on 2023/8/23.
//

import UIKit

public protocol RemoteImageDownloader {
    /// 加载图片到imageview
    func setImage(_ url: String, at imageView: UIImageView)
}
