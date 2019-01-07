//
//  NSMutableAttributedString+setAsLink.swift
//  imageorg
//
//  Created by Finn Schlenk on 23.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {

    @discardableResult public func setAsLink(textToFind: String, link: String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)

        guard let encodedLink = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: encodedLink) else {
            return false
        }

        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: url, range: foundRange)
            return true
        }

        return false
    }
}
