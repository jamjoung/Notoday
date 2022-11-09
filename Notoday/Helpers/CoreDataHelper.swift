//
//  CoreDataHelper.swift
//  Notoday
//
//  Created by Jamie Joung on 11/8/22.
//

import Foundation
import CoreData

class CoreDataHelper {
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataHelper = CoreDataHelper()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "NoteModel")
        persistentContainer.loadPersistentStores {
            description, error in
            if let error = error {
                fatalError("Error initializing core data: \(error)")
            }
        }
    }
}
