//
//  DeletionConfirmationAlert.swift
//  imageorg
//
//  Created by Finn Schlenk on 16.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class DeletionConfirmationAlert: NSAlert {

    convenience init(numberOfItems: Int) {
        self.init()

        icon = NSImage(imageLiteralResourceName: "NSCaution")
        messageText = "Delete items"
        informativeText = "You are about to delete \(numberOfItems) items. Are you sure you want to delete them?"
        let confirmationButton = addButton(withTitle: "Yes")
        let cancelButton = addButton(withTitle: "Cancel")

        confirmationButton.tag = NSApplication.ModalResponse.OK.rawValue
        cancelButton.tag = NSApplication.ModalResponse.cancel.rawValue
    }
}
