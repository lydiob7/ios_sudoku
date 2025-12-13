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
                        .foregroundStyle(isGameBlocked ? Color("DisabledText") : Color("TextColor"))
                }
                .disabled(isGameBlocked)
                Text("undo")
                    .foregroundColor(isGameBlocked ? Color("DisabledText") : Color("TextColor"))
            }
            Spacer()
            VStack {
                Button {
                    sudoku.eraseTile()
                } label: {
                    Image(systemName: "eraser")
                        .font(.system(size: 30))
                        .foregroundStyle(isGameBlocked ? Color("DisabledText") : Color("TextColor"))
                }
                .disabled(isGameBlocked)
                Text("erase")
                    .foregroundColor(isGameBlocked ? Color("DisabledText") : Color("TextColor"))
            }
            Spacer()
            VStack {
                ZStack {
                    Button {
                        sudoku.toggleNotesMode()
                    } label: {
                        Image(systemName: "pencil.line")
                            .font(.system(size: 30))
                            .foregroundStyle(isGameBlocked ? Color("DisabledText") : Color("TextColor"))
                    }
                    .disabled(isGameBlocked)
                    Text(sudoku.isNotesMode ? "on": "off")
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(maxWidth: 34, maxHeight: 20)
                        .background(sudoku.isNotesMode && !isGameBlocked ? Color("AccentColor") : Color("DisabledText"))
                        .clipShape(.capsule)
                        .offset(x: 20, y: -14)
                }
                Text("notes")
                    .foregroundColor(isGameBlocked ? Color("DisabledText") : Color("TextColor"))
            }
            Spacer()
            VStack {
                ZStack {
                    Button {
                        sudoku.showHint()
                    } label: {
                        Image(systemName: "lightbulb")
                            .font(.system(size: 30))
                            .foregroundStyle(sudoku.availableHints == 0 || isGameBlocked ? Color("DisabledText") : Color("TextColor"))
                    }
                    .disabled(sudoku.availableHints == 0 || isGameBlocked)
                    
                    if (sudoku.availableHints > 0) {
                        Text("\(sudoku.availableHints)")
                            .font(.caption)
                            .foregroundColor(Color("TextColor"))
                            .frame(maxWidth: 20, maxHeight: 20)
                            .background(isGameBlocked ? Color("DisabledText") : Color("AccentColor"))
                            .clipShape(.circle)
                            .offset(x: 10, y: -14)
                            
                    }
                }
                Text("hint")
                    .foregroundColor(sudoku.availableHints == 0 || isGameBlocked ? Color("DisabledText") : Color("TextColor"))
            }
        }
        .padding(.horizontal)
        
        HStack {
            ForEach(0..<9) { num in
                Button(String(num + 1)) {
                    sudoku.guess(num + 1)
                }
                .foregroundColor(isGameBlocked ? Color("DisabledText") : Color("TextColor"))
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(width: 33, height: 50)
                .disabled(isGameBlocked)
            }
        }
        .padding(.horizontal)
    }
}
