//
//  NSAppearance+isDarkMode.swift
//  imageorg
//
//  Created by Finn Schlenk on 26.07.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

extension NSAppearance {

    var isDarkMode: Bool {
        if #available(OSX 10.14, *) {
            return bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        }
        return false
    }
}
