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
            
            Text("Sudoku App")
                .bold()
                .font(.largeTitle)
            
            Text("by Lydiob7")
                .padding(.bottom)
            
            VStack {
                Text("Sudoku Level")
                
                Picker("Difficulty", selection: $difficulty) {
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
                    Text("Start a new Sudoku")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color("AccentColor"))
                        .border(Color.black)
                })

                if hasSavedSudoku {
                    NavigationLink(value: "continueSudoku", label: {
                        Text("Resume Sudoku")
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink(value: "settings", label: {
                    Label("Settings", systemImage: "gearshape")
                })
            }
            .foregroundStyle(Color("TextColor"))
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
