//
//  AutoscrollClipView.swift
//  imageorg
//
//  Created by Finn Schlenk on 20.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class AutoscrollClipView: NSClipView {

    override func autoscroll(with event: NSEvent) -> Bool {
        guard let mouseLocationInWindow = window?.mouseLocationOutsideOfEventStream else {
            return false
        }

        let isMouseOutsideOfWindow = !isMousePoint(mouseLocationInWindow, in: frame)
        guard isMouseOutsideOfWindow else {
            return false
        }

        let viewMouseLocationY = event.locationInWindow.y
        let difference = viewMouseLocationY - mouseLocationInWindow.y

        let newPoint = NSPoint(x: documentVisibleRect.origin.x, y: documentVisibleRect.origin.y + difference)

        scroll(newPoint)

        return true
    }
}
