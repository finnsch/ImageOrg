//
//  SortOrder.swift
//  imageorg
//
//  Created by Finn Schlenk on 09.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

enum SortOrder: CaseIterable {
    case createdAt
    case name
    case favorites

    var title: String {
        switch self {
        case .createdAt:
            return "Date"
        case .name:
            return "Name"
        case .favorites:
            return "Favorites"
        }
    }
}
