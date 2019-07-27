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

    var isSidebarEnabled: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKey.isSidebarEnabled.rawValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewController?.navigationController = navigationController
        sidebarViewController?.navigationController = navigationController

        if isSidebarEnabled {
            showSidebar(animating: false)
        } else {
            collapseSidebar(animating: false)
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        mediaWindowController?.toggleSidebar = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            if strongSelf.isSidebarEnabled {
                strongSelf.collapseSidebar()
            } else {
                strongSelf.showSidebar()
            }

            UserDefaults.standard.set(!strongSelf.isSidebarEnabled, forKey: UserDefaultKey.isSidebarEnabled.rawValue)
        }
    }

    func showSidebar(animating: Bool = true) {
        guard var sidebar = self.splitViewItems.last, sidebar.isCollapsed else {
            return
        }

        if animating {
            sidebar = sidebar.animator()
        }

        sidebar.isCollapsed = false
    }

    func collapseSidebar(animating: Bool = true) {
        guard var sidebar = self.splitViewItems.last, !sidebar.isCollapsed else {
            return
        }

        if animating {
            sidebar = sidebar.animator()
        }

        sidebar.isCollapsed = true
    }
}

// MARK: - NSSplitViewDelegate
extension MediaSplitViewController {

    override func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        return NSZeroRect
    }
}
