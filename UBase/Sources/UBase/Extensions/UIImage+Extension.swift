//
//  UIImage+Extension.swift
//  BasicFramework
//
//  Created by dev-02 on 2018/8/15.
//  Copyright © 2018年 泽i. All rights reserved.
//

import Foundation
import UIKit

//public enum WechatCompressType {
//    case session
//    case timeline
//    case headIcon
//}
//
//public extension WechatCompressType {
//    var boundary: CGFloat {
//        switch self {
//        case .session:
//            return 800
//        case .timeline:
//            return 1280
//        case .headIcon:
//            return 200
//        }
//    }
//}
//
//public extension UIImage {
//    /**
//     wechat image compress
//
//     - parameter type: session image boundary is 800, timeline is 1280
//
//     - returns: thumb image
//     */
//    func wxCompress(type: WechatCompressType = .timeline) -> UIImage {
//        let size = self.wxImageSize(type: type)
//        let reImage = resizedImage(size: size)
//        guard let data = reImage.jpegData(compressionQuality: 0.5) else {
//            return UIImage()
//        }
//        return UIImage(data: data) ?? UIImage()
//    }
//}
//
//private extension UIImage {
//    /**
//     get wechat compress image size
//
//     - parameter type: session  / timeline
//
//     - returns: size
//     */
//    func wxImageSize(type: WechatCompressType) -> CGSize {
//        var width = size.width
//        var height = size.height
//
////        var boundary: CGFloat = 1280
//
//        // width, height <= 1280, Size remains the same
//        guard width > type.boundary || height > type.boundary else {
//            return CGSize(width: width, height: height)
//        }
//
//        // aspect ratio
//        let s = max(width, height) / min(width, height)
//        if s <= 2 {
//            // Set the larger value to the boundary, the smaller the value of the compression
//            let x = max(width, height) / type.boundary
//            if width > height {
//                width = type.boundary
//                height /= x
//            } else {
//                height = type.boundary
//                width /= x
//            }
//        } else {
//            // width, height > 1280
//            if min(width, height) >= type.boundary {
//                // Set the smaller value to the boundary, and the larger value is compressed
//                let x = min(width, height) / type.boundary
//                if width < height {
//                    width = type.boundary
//                    height /= x
//                } else {
//                    height = type.boundary
//                    width /= x
//                }
//            }
//        }
//        return CGSize(width: width, height: height)
//    }
//
//    /**
//     Zoom the picture to the specified size
//
//     - parameter newSize: image size
//
//     - returns: new image
//     */
//    func resizedImage(size: CGSize) -> UIImage {
//        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        var newImage: UIImage!
//        UIGraphicsBeginImageContext(newRect.size)
//        newImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
//        newImage.draw(in: newRect)
//        newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//}
//
//public extension UIImage {
//
//    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
//        let rect = CGRect(origin: .zero, size: size)
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
//        color.setFill()
//        UIRectFill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        guard let cgImage = image?.cgImage else { return nil }
//        self.init(cgImage: cgImage)
//    }
//
//    /// 使用文件路径初始化一个图像
//    /// - Parameters:
//    ///   - path: 文件路径
//    ///   - scale: 缩放系数
//    convenience init?(path: String, scale: CGFloat) {
//        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
//            return nil
//        }
//        self.init(data: data, scale: scale)
//    }
//}
//
//public extension UIImage {
//    /// 通过地址获取图片尺寸
//    func sizeOfImageAt(url: URL?) -> CGSize {
//        guard let url = url else {
//            return .zero
//        }
//
//        // with CGImageSource we avoid loading the whole image into memory
//        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
//            return .zero
//        }
//
//        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//        // 访问图片属性
//        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
//            return .zero
//        }
//
//        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
//           let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
//            return CGSize(width: width, height: height)
//        } else {
//            return .zero
//        }
//    }
//}
