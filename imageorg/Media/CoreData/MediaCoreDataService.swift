//
//  MediaCoreDataService.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa
import CoreData

class MediaCoreDataService {

    // MARK: - Properties

    let managedObjectContext = CoreDataStack.shared.managedContext
    let coreDataStack = CoreDataStack.shared

    // MARK: - Methods

    func getMediaItems() -> [Media] {
        let request: NSFetchRequest<Media> = Media.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Media.creationDate), ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            let result = try managedObjectContext.fetch(request)

            return result
        } catch let error as NSError {
            print("Could not fetch media items: \(error.localizedDescription)")
        }

        return []
    }

    func update(media: Media) -> Media {
        media.modificationDate = NSDate()
        coreDataStack.saveContext()

        return media
    }

    func delete(media: Media) {
        managedObjectContext.delete(media)
        coreDataStack.saveContext()
    }

    func exists(with hashId: String) -> Bool {
        let predicate = NSPredicate(format: "%K = %@", #keyPath(Media.hashId), hashId)
        let request = NSFetchRequest<NSDictionary>(entityName: "Media")
        request.predicate = predicate

        do {
            let count = try managedObjectContext.count(for: request)

            return count > 0
        } catch let error as NSError {
            print("Could not verify if media exists already: \(error.localizedDescription)")
        }

        return true
    }

    func createImage(hashId: String, name: String, description: String?, mimeType: String, fileSize: Int,
                     filePath: String, originalFilePath: String, thumbnail: Thumbnail) -> Image {
        let image = Image(context: managedObjectContext)

        image.hashId = hashId
        image.id = UUID()
        image.name = name
        image.desc = description
        image.mimeType = mimeType
        image.fileSize = fileSize
        image.filePath = filePath
        image.originalFilePath = originalFilePath
        image.thumbnail = thumbnail
        image.creationDate = NSDate()

        coreDataStack.saveContext()

        return image
    }

    func createVideo(hashId: String, name: String, description: String?, mimeType: String, fileSize: Int,
                     filePath: String, originalFilePath: String, thumbnail: Thumbnail) -> Video {
        let video = Video(context: managedObjectContext)

        video.hashId = hashId
        video.id = UUID()
        video.name = name
        video.desc = description
        video.mimeType = mimeType
        video.fileSize = fileSize
        video.filePath = filePath
        video.originalFilePath = originalFilePath
        video.thumbnail = thumbnail
        video.creationDate = NSDate()

        coreDataStack.saveContext()

        return video
    }
}
