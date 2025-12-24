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
//  HomeView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 29/06/2025.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath
    @Binding var difficulty: Difficulty
    
    var hasSavedSudoku: Bool {
        UserDefaults.standard.data(forKey: SAVED_SUDOKU_KEY) != nil
    }
    
    var body: some View {
        VStack {
            Image("SudokuIcon")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("app_title")
                .bold()
                .font(.largeTitle)
            
            Text("by_lydiob7")
                .padding(.bottom)
            
            VStack {
                Text("sudoku_level")
                
                Picker("difficulty", selection: $difficulty) {
                    ForEach(Difficulty.allCases) { level in
                        Text(level.description).tag(level)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color("TextColor"))
            }
            .padding()
            
            VStack(spacing: 16) {
                NavigationLink(value: "newSudoku", label: {
                    Text("start_new")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color("AccentColor"))
                        .border(Color.black)
                })

                if hasSavedSudoku {
                    NavigationLink(value: "continueSudoku", label: {
                        Text("resume_game")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.clear)
                            .border(Color.black)
                    })
                }
            }
            .frame(width: 300)
            .background(Color("AppBackground"))
        }
            .navigationTitle("home_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Center title (controls color explicitly)
                ToolbarItem(placement: .principal) {
                    Text("home_title")
                        .foregroundStyle(Color("TextColor"))
                        .font(.headline)
                }

                // Settings button (right side)
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: "settings") {
                        Label("settings_title", systemImage: "gearshape")
                    }
                }
            }
    }
}

#Preview {
    @State @Previewable var pathStore = PathStore()
    @State @Previewable var difficulty: Difficulty = .medium
    
    ZStack {
        Color("AppBackground")
            .ignoresSafeArea()
        
        HomeView(path: $pathStore.path, difficulty: $difficulty)
    }
}
