//
//  ContentView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 16/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State var pathStore = PathStore()
    @State var difficulty: Difficulty = .medium
    @State var maxOfHints = 1
    @State var maxOfMistakes = 3
    
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                
                HomeView(path: $pathStore.path, difficulty: $difficulty)
                    .foregroundStyle(Color("TextColor"))
                    .navigationDestination(for: String.self) { value in
                        switch value {
                            case "continueSudoku":
                                ZStack {
                                    Color("AppBackground")
                                        .ignoresSafeArea()
                                    
                                    SudokuView(difficulty: difficulty, maxOfMistakes: maxOfMistakes, maxOfHints: maxOfHints)
                                        .foregroundStyle(Color("TextColor"))
                                }
                            case "newSudoku":
                                ZStack {
                                    Color("AppBackground")
                                        .ignoresSafeArea()
                                    
                                    SudokuView(difficulty: difficulty, maxOfMistakes: maxOfMistakes, maxOfHints: maxOfHints, startNew: true)
                                        .foregroundStyle(Color("TextColor"))
                                }
       
                            case "settings":
                                ZStack {
                                    Color("AppBackground")
                                        .ignoresSafeArea()
                                    
                                    SettingsView()
                                        .foregroundStyle(Color("TextColor"))
                                }
                            default:
                                EmptyView()
                            }
                        }
                }
            }
        }
}

#Preview {
    ContentView()
}
