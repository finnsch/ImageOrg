//
//  Thumbnail+CoreDataProperties.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//
//

import Cocoa
import CoreData

extension Thumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
    }

    @NSManaged public var filePath: String
    @NSManaged public var height: Float
    @NSManaged public var width: Float
    @NSManaged public var media: Media

}
