//
//  ContentView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 16/07/2024.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        NavigationStack {
            SudokuView()
                .navigationTitle("Sudoku")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Settings", systemImage: "gearshape") {
                        
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
