//
//  NotodayApp.swift
//  Notoday
//
//  Created by Jamie Joung on 11/6/22.
//

import SwiftUI

@main
struct NotodayApp: App {
    let persistentContainer = CoreDataHelper.shared.persistentContainer
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
