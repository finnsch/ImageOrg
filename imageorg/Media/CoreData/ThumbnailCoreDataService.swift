//
//  ThumbnailCoreDataService.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa
import CoreData

class ThumbnailCoreDataService {

    // MARK: - Properties

    let managedObjectContext = CoreDataStack.shared.managedContext
    let coreDataStack = CoreDataStack.shared

    // MARK: - Methods

    func createThumbnail(filePath: String, width: Float, height: Float) -> Thumbnail {
        let thumbnail = Thumbnail(context: managedObjectContext)

        thumbnail.filePath = filePath
        thumbnail.width = width
        thumbnail.height = height

        coreDataStack.saveContext()

        return thumbnail
    }
}
