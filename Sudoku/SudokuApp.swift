//
//  SudokuApp.swift
//  Sudoku
//
//  Created by Tomi Scattini on 16/07/2024.
//

import SwiftUI
import SwiftData

@main
struct SudokuApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: HistoricSudoku.self)
    }
}
