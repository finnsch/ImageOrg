//
//  SplitViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 21.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaSplitViewController: NSSplitViewController {

    var selectedMedia: Media? {
        didSet {
            mediaDetailViewController?.selectedMedia = selectedMedia
        }
    }

    var mediaGridViewController: MediaGridViewController? {
        if let mediaGridSplitViewItem = splitViewItems.first {
            return mediaGridSplitViewItem.viewController as? MediaGridViewController
        }

        return nil
    }

    var mediaDetailViewController: MediaSidebarViewController? {
        if let mediaDetailSplitViewItem = splitViewItems.last {
            return mediaDetailSplitViewItem.viewController as? MediaSidebarViewController
        }

        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let mediaGridViewController = mediaGridViewController {
            mediaGridViewController.delegate = self
        }
    }

    override func viewDidAppear() {
        NSApplication.shared.keyWindow?.title = "Gallery"
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

// MARK: - MediaGridDelegate
extension MediaSplitViewController: MediaGridDelegate {
    
    func didSelectItem(with media: Media?) {
        selectedMedia = media
    }

    func didSelectDetail(with media: Media?) {
        guard let mediaDetailViewController = storyboard?.instantiateController(withIdentifier: "MediaDetailViewController") as? MediaDetailViewController else {
            return
        }
        mediaDetailViewController.media = media
        mediaDetailViewController.delegate = self

        navigationController?.pushViewController(mediaDetailViewController, animated: false)
    }
}

// MARK: - MediaDetailDelegate
extension MediaSplitViewController: MediaDetailDelegate {

    func handleNext() {
        navigationController?.popViewController(animated: false)
        mediaGridViewController?.showNext()
    }

    func handlePrevious() {
        navigationController?.popViewController(animated: false)
        mediaGridViewController?.showPrevious()
    }
}
