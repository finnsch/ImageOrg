//
//  CenteredClipView.swift
//  imageorg
//
//  Created by Finn Schlenk on 24.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

final class CenteredClipView: NSClipView {
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        var constrainedClipViewBounds = super.constrainBoundsRect(proposedBounds)

        guard let documentView = documentView else {
            return constrainedClipViewBounds
        }

        let documentViewFrame = documentView.frame

        // If proposed clip view bounds width is greater than document view frame width, center it horizontally.
        if documentViewFrame.width < proposedBounds.width {
            constrainedClipViewBounds.origin.x = floor((proposedBounds.width - documentViewFrame.width) / -2.0)
        }

        // If proposed clip view bounds height is greater than document view frame height, center it vertically.
        if documentViewFrame.height < proposedBounds.height {
            constrainedClipViewBounds.origin.y = floor((proposedBounds.height - documentViewFrame.height) / -2.0)
        }

        return constrainedClipViewBounds
    }
}
