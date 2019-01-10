//
//  AppDelegate.swift
//  imageorg
//
//  Created by Finn Schlenk on 21.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("[CoreData] CoreData store path: \(CoreDataStack.shared.storeURL.absoluteString)")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
