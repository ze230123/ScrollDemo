//
//  String+Extension.swift
//  NetWork
//
//  Created by 泽i on 2018/8/7.
//  Copyright © 2018年 泽i. All rights reserved.
//

import UIKit

public extension String {
    func range(of sub: String) -> NSRange {
        return (self as NSString).range(of: sub)
    }

    func substring(range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }
}

public extension String {

    /// 字符串宽度计算
    /// - Parameters:
    ///   - font: 字体
    ///   - height: 高度
    /// - Returns: 宽度
    func widthRect(with font: UIFont, height: CGFloat) -> CGFloat {
        let string = self as NSString
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let att: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        return string.boundingRect(with: size,
                                   options: .usesLineFragmentOrigin, attributes: att,
                                   context: nil).width
    }

    /// 获取字符串高度
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 字符串可显示宽度
    /// - Returns: 高度
    func heightRect(with font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let text = self as NSString
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let rect =  text.boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
        return ceil(rect.size.height)
    }

    /// 无效值显示`-`
    ///
    /// 无效值包括: `0`、`""`
    var invalid: String {
        if self == "" || self == "0" {
            return "-"
        }
        return self
    }

    /// 将 `0`、"" 转为 "-"
    var percentValid: String {
        if self == "" || self == "0" {
            return "-"
        }
        return "\(self)%"
    }

    /// 删除HTML标签
    func removeHtml() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    /// 隐藏手机号码中间4位
    var securePhone: String {
        let prefix = self.prefix(3)
        let suffix = self.suffix(4)
        return String(prefix) + "****" + String(suffix)
    }
}

public extension String {
    var toJSON: [String: Any] {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
        if let data = data {
            let parsedJSON: [String: Any]?
            do {
                parsedJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
            } catch let error {
                debugPrint(error)
                parsedJSON = nil
            }
            return parsedJSON ?? [:]
        }
        return [:]
    }
}

public extension String {
    var intValue: Int {
        let intString = self == "-" ? "" : self
        return Int(intString) ?? 0
    }

    var boolValue: Bool? {
        return Bool(self)
    }

    var doubleValue: Double {
        return Double(self) ?? 0
    }
}

public extension String {
    var isVideoUrl: Bool {
        return hasSuffix("mp4")
    }

    /// 去除所有空格
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }

    /// 不会空
    var isNotEmpty: Bool {
        return !isEmpty
    }

    var length: Int {
        return utf16.count
    }
}

public extension String {
    // 使用正则表达式替换
    func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try? NSRegularExpression(pattern: pattern, options: options)
        return regex?.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: with) ?? ""
    }
}

public extension String {
//    var urlValue: String {
//        guard self.hasPrefix("http:") || hasPrefix("https:") else {
//            return "https:" + self
//        }
//        return self
//    }
}

public extension Optional where Wrapped == String {
    /// 路由协议 可选字符串转int值
    var routerValue: Int? {
        guard let int = self else {
            return nil
        }
        return Int(int)
    }

    /// 可选无效值显示`-`
    /// 无效值包括: `0`、`""`
    var optionInvalid: String {
        guard let text = self else {
            return "-"
        }
        return text.invalid
    }

    /// 可选默认显示`“”`
    var optionEmpty: String {
        guard let text = self else {
            return ""
        }
        return text
    }
}
