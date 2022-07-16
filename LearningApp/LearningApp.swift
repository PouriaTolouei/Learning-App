//
//  LearningApp.swift
//  LearningApp
//
//  Created by Pouria Tolouei on 16/07/2022.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
