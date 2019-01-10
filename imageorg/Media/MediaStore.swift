//
//  MediaSelection.swift
//  imageorg
//
//  Created by Finn Schlenk on 08.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

protocol MediaStoreDelegate: class {
    func didSelect(media: Media?)
    func didUpdate(media: Media, at index: Int)
    func didDelete(media: Media, at index: Int)
    func didSelectNext()
    func didSelectPrevious()
}

extension MediaStoreDelegate {
    func didSelect(media: Media?) {}
    func didUpdate(media: Media, at index: Int) {}
    func didDelete(media: Media, at index: Int) {}
    func didSelectNext() {}
    func didSelectPrevious() {}
}

class MediaStore {

    static let shared = MediaStore()

    var delegates: [MediaStoreDelegate] = []
    var numberOfItems: Int {
        return mediaItems.count
    }
    var mediaItems: [Media] = []
    var selectedMedia: Media? {
        didSet {
            delegates.forEach { $0.didSelect(media: selectedMedia) }
        }
    }

    func update(media: Media) {
        guard let index = mediaItems.firstIndex(where: { $0 === media }) else {
            return
        }

        mediaItems[index] = media

        if (media === selectedMedia) {
            selectedMedia = media
        }

        delegates.forEach { $0.didUpdate(media: media, at: index) }
    }

    func delete(media: Media) -> Bool {
        guard let index = mediaItems.firstIndex(where: { $0 === media }) else {
            return false
        }

        mediaItems.remove(at: index)

        if (media === selectedMedia) {
            selectedMedia = nil
        }

        delegates.forEach { $0.didDelete(media: media, at: index) }

        return true
    }

    func selectNext() {
        guard let index = mediaItems.firstIndex(where: { $0 === selectedMedia }) else {
            return
        }

        let nextIndex: Int = numberOfItems <= index + 1 ? 0 : index + 1

        selectedMedia = mediaItems[nextIndex]

        delegates.forEach { $0.didSelectNext() }
    }

    func selectPrevious() {
        guard let index = mediaItems.firstIndex(where: { $0 === selectedMedia }) else {
            return
        }

        let previousIndex: Int = 0 > index - 1 ? mediaItems.count - 1 : index - 1

        selectedMedia = mediaItems[previousIndex]

        delegates.forEach { $0.didSelectPrevious() }
    }

    func add(delegate: MediaStoreDelegate) {
        guard isNew(delegate: delegate) else {
            return
        }

        delegates.append(delegate)
    }

    func remove(delegate: MediaStoreDelegate) {
        delegates.removeAll { $0 === delegate }
    }

    private func isNew(delegate: MediaStoreDelegate) -> Bool {
        return !delegates.contains(where: { $0 === delegate })
    }
}
