// This file is part of Sudoku b7.
//
// Copyright (C) 2024 Tomás Scattini
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
