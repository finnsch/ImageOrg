//
//  MediaDestructor.swift
//  imageorg
//
//  Created by Finn Schlenk on 12.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

class MediaDestructor {

    private var mediaItems: [Media]
    private var mediaStore = MediaStore.shared
    private var mediaCoreDataService: MediaCoreDataService

    init(mediaItems: [Media]) {
        self.mediaItems = mediaItems
        self.mediaCoreDataService = MediaCoreDataService()
    }

    func delete() {
        mediaItems.forEach { media in
            deleteSingle(media)
        }
    }

    private func deleteSingle(_ media: Media) {
        do {
            try media.deleteFromFileSystem()
        } catch {
            print("Could not delete media from file system: \(error)")
        }

        let _ = mediaStore.delete(media: media)
        mediaCoreDataService.delete(media: media)
    }
}
