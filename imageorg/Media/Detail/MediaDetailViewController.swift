//
//  MediaDetailViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 23.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaDetailViewController: MediaViewController {

    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var zoomControlsStackView: NSStackView!

    private let delete: UInt16 = 0x33
    private let leftArrow: UInt16 = 0x7B
    private let rightArrow: UInt16 = 0x7C

    var keyDownMonitor: Any!
    var imageViewerViewController: ImageViewerViewController?
    var videoViewerViewController: VideoViewerViewController?
    var mediaStore = MediaStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        NSApplication.shared.keyWindow?.title = mediaStore.selectedMedia?.name ?? ""

        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            guard let strongSelf = self else {
                return nil
            }

            if strongSelf.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }

        if mediaStore.selectedMedia is Image {
            setupImageViewer()
        } else if mediaStore.selectedMedia is Video {
            setupVideoViewer()
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterFullScreen), name: NSWindow.didEnterFullScreenNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleExitFullScreen), name: NSWindow.willExitFullScreenNotification, object: nil)
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()

        NSEvent.removeMonitor(keyDownMonitor)
        NotificationCenter.default.removeObserver(self, name: NSWindow.didEnterFullScreenNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSWindow.willExitFullScreenNotification, object: nil)
    }

    func setupImageViewer() {
        zoomControlsStackView.isHidden = false

        imageViewerViewController = ImageViewerViewController(nibName: "ImageViewerViewController", bundle: Bundle.main)
        addChild(imageViewerViewController!)
        containerView.addSubview(imageViewerViewController!.view)

        imageViewerViewController!.image = mediaStore.selectedMedia as? Image
        imageViewerViewController!.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageViewerViewController!.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            imageViewerViewController!.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            imageViewerViewController!.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            imageViewerViewController!.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
        ])
    }

    func setupVideoViewer() {
        zoomControlsStackView.isHidden = true

        videoViewerViewController = VideoViewerViewController(nibName: "VideoViewerViewController", bundle: Bundle.main)
        addChild(videoViewerViewController!)
        containerView.addSubview(videoViewerViewController!.view)

        videoViewerViewController!.video = mediaStore.selectedMedia as? Video
        videoViewerViewController!.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            videoViewerViewController!.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            videoViewerViewController!.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            videoViewerViewController!.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            videoViewerViewController!.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
        ])
    }

    func setupFullscreenImageViewer() {
        guard let image = mediaStore.selectedMedia as? Image else {
            return
        }

        let fullscreenImageViewerViewController = FullscreenImageViewerViewController(nibName: "FullscreenImageViewerViewController", bundle: Bundle.main)
        fullscreenImageViewerViewController.setup(with: image)

        navigationController?.pushViewController(fullscreenImageViewerViewController, animated: false)
    }

    func myKeyDown(with event: NSEvent) -> Bool {
        guard !(view.window?.firstResponder is NSTextView) else {
            return false
        }

        // handle keyDown only if current window has focus, i.e. is keyWindow
        guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return false }
        switch event.keyCode {
        case delete:
            navigationController?.popViewController(animated: false)
            return true
        case leftArrow:
            mediaStore.selectPrevious()
            return true
        case rightArrow:
            mediaStore.selectNext()
            return true
        default:
            return false
        }
    }
    
    @IBAction func handleBackButton(_ sender: NSButton) {
        navigationController?.popViewController(animated: false)
    }

    @IBAction func handleDeleteButton(_ sender: NSButton) {
        guard let media = mediaStore.selectedMedia else {
            return
        }

        let mediaCoreDataService = MediaCoreDataService()

        do {
            try media.deleteFromFileSystem()
        } catch {
            print("Could not delete media from file system.")
            return
        }

        let _ = mediaStore.delete(media: media)
        mediaCoreDataService.delete(media: media)
        navigationController?.popViewController(animated: false)
    }

    @IBAction func handleZoomInButton(_ sender: NSButton) {
        imageViewerViewController?.zoomIn()
    }

    @IBAction func handleZoomOutButton(_ sender: Any) {
        imageViewerViewController?.zoomOut()
    }

    @IBAction func handleZoomToFit(_ sender: NSButton) {
        imageViewerViewController?.zoomToFit()
    }

    @objc func handleEnterFullScreen(_ notification: NSNotification) {
        setupFullscreenImageViewer()
    }

    @objc func handleExitFullScreen(_ notification: NSNotification) {
        navigationController?.popViewController(animated: false)
    }
}

extension NSRect {
    func centerAndAdjustPercentage(percentage p: CGFloat) -> NSRect {
        let w = self.width
        let h = self.height

        let newW = w * p
        let newH = h * p
        let newX = (w - newW) / 2
        let newY = (h - newH) / 2

        return NSRect(x: newX, y: newY, width: newW, height: newH)
    }
}
