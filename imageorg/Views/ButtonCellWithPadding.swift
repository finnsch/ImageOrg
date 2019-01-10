//
//  ButtonCellWithPadding.swift
//  imageorg
//
//  Created by Finn Schlenk on 10.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class ButtonCellWithPadding: NSButtonCell {

    @IBInspectable var paddingPercentage: CGFloat = 1.0

    override func imageRect(forBounds rect: NSRect) -> NSRect {
        let newRect = rect.centerAndAdjustPercentage(percentage: paddingPercentage)
        return newRect
    }
}
