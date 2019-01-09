//
//  Media+CoreDataProperties.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//
//

import Foundation
import CoreData

extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var creationDate: NSDate
    @NSManaged public var desc: String?
    @NSManaged public var id: UUID
    @NSManaged public var mimeType: String
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var name: String
    @NSManaged public var filePath: String
    @NSManaged public var hashId: String
    @NSManaged public var originalFilePath: String
    @NSManaged public var fileSize: Int
    @NSManaged public var whereFrom: String?
    @NSManaged public var thumbnail: Thumbnail

}
