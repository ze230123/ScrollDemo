//
//  NSAttributedString+Extensions.swift
//  YouYiKao
//
//  Created by 张泽群 on 2022/4/19.
//

import Foundation

public extension NSMutableAttributedString {
    convenience init?(htmlString: String?, attributes: [NSAttributedString.Key: Any]? = nil) {
        guard let data = htmlString?.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
            .defaultAttributes: attributes ?? [:]
        ]

        try? self.init(data: data, options: options, documentAttributes: nil)
        addAttributes(attributes ?? [:], range: NSRange(location: 0, length: string.count))
    }
}
