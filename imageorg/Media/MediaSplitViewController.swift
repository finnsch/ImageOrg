//
//  SplitViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 21.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaSplitViewController: NSSplitViewController {

    var mainViewController: NSViewController? {
        return splitViewItems.first?.viewController
    }

    var sidebarViewController: NSViewController? {
        return splitViewItems.last?.viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController?.navigationController = navigationController
        sidebarViewController?.navigationController = navigationController
    }

    func showSidebar() {
        splitViewItems.last?.isCollapsed = false
    }

    func collapseSidebar() {
        splitViewItems.last?.isCollapsed = true
    }
}

// MARK: - NSSplitViewDelegate
extension MediaSplitViewController {

    override func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        return NSZeroRect
    }
}
