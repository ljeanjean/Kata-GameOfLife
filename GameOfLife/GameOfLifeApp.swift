//
//  GameOfLifeApp.swift
//  GameOfLife
//
//  Created by Laurent Jeanjean on 30/04/2025.
//

import SwiftUI

@main
struct GameOfLifeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 512, height: 512)
        .windowResizability(.contentSize)
    }
}
