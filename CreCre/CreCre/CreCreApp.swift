//
//  CreCreApp.swift
//  CreCre
//
//  Created by 윤혜주 on 9/17/25.
//

import SwiftUI
import CoreData

@main
struct CreCreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
