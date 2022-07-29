//
//  Code_BudApp.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 25/07/22.
//

import SwiftUI

@main
struct Code_BudApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
