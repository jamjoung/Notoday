//
//  NotodayApp.swift
//  Notoday
//
//  Created by Jamie Joung on 11/6/22.
//

import SwiftUI

@main
struct NotodayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
