//
//  CreateApp.swift
//  Create
//
//  Created by Henry Chau.
//

import SwiftUI

@main
struct CreateApp: App {
    @StateObject private var model = Model()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
