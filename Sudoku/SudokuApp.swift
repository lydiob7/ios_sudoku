//
//  SudokuApp.swift
//  Sudoku
//
//  Created by Tomi Scattini on 16/07/2024.
//

import SwiftUI

@main
struct SudokuApp: App {
    @AppStorage(APP_LANGUAGE_KEY) private var appLanguage = DEFAULT_LANGUAGE_KEY
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.locale,
                    Locale(identifier: appLanguage)
                )
        }
    }
}
