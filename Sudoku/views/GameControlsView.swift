//
//  GameControls.swift
//  Sudoku
//
//  Created by Tomi Scattini on 07/08/2024.
//

import SwiftUI

struct GameControlsView: View {
    @Binding var sudoku: Sudoku
    var isGameBlocked: Bool
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    sudoku.undo()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 30))
                }
                .disabled(isGameBlocked)
                Text("Undo")
                    .foregroundColor(isGameBlocked ? .gray : .accentColor)
            }
            Spacer()
            VStack {
                Button {
                    sudoku.eraseTile()
                } label: {
                    Image(systemName: "eraser")
                        .font(.system(size: 30))
                }
                .disabled(isGameBlocked)
                Text("Erase")
                    .foregroundColor(isGameBlocked ? .gray : .accentColor)
            }
            Spacer()
            VStack {
                ZStack {
                    Button {
                        sudoku.toggleNotesMode()
                    } label: {
                        Image(systemName: "pencil.line")
                            .font(.system(size: 30))
                    }
                    .disabled(isGameBlocked)
                    Text(sudoku.isNotesMode ? "ON": "OFF")
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(maxWidth: 34, maxHeight: 20)
                        .background(sudoku.isNotesMode && !isGameBlocked ? Color.primary : Color.gray)
                        .clipShape(.capsule)
                        .offset(x: 20, y: -14)
                }
                Text("Notes")
                    .foregroundColor(isGameBlocked ? .gray : .accentColor)
            }
            Spacer()
            VStack {
                ZStack {
                    Button {
                        sudoku.showHint()
                    } label: {
                        Image(systemName: "lightbulb")
                            .font(.system(size: 30))
                    }
                    .disabled(sudoku.availableHints == 0 || isGameBlocked)
                    
                    if (sudoku.availableHints > 0) {
                        Text("\(sudoku.availableHints)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(maxWidth: 20, maxHeight: 20)
                            .background(isGameBlocked ? Color.gray : Color.red)
                            .clipShape(.circle)
                            .offset(x: 10, y: -14)
                            
                    }
                }
                Text("Hint")
                    .foregroundColor(sudoku.availableHints == 0 || isGameBlocked ? .gray : .accentColor)
            }
        }
        .padding(.horizontal)
        
        HStack {
            ForEach(0..<9) { num in
                Button(String(num + 1)) {
                    sudoku.guess(num + 1)
                }
                .foregroundColor(.accentColor)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(width: 33, height: 50)
                .disabled(isGameBlocked)
            }
        }
        .padding(.horizontal)
    }
}
