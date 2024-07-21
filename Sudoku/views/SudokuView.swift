//
//  SudokuView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import SwiftUI

struct SudokuView: View {
    static var difficulty: Difficulty = .easy
    static var maxOfMistakes: Int = 3
    static var maxOfHints: Int = 1
    
    @State public var sudoku = SudokuGenerator(difficulty: difficulty, maxOfMistakes: maxOfMistakes, maxOfHints: maxOfHints)
    let tileWidth: CGFloat = 40
    let tileHeight: CGFloat = 49
    let dividerWidth: CGFloat = 3
    
    @ViewBuilder var body: some View {
        
            VStack(spacing: 30) {
                HStack {
                    VStack {
                        Text("Mistakes")
                        Text("\(sudoku.errorsCount) / 3")
                    }
                    Spacer()
                    VStack {
                        Text("Level")
                        Text("\(Self.difficulty.description)")
                    }
                    Spacer()
                    VStack {
                        Text("Score")
                        Text("\(sudoku.score)")
                    }
                    Spacer()
                    VStack {
                        Text("Time")
                        Text("\(Sudoku.elapsedTime)")
                    }
                }
                .padding(.horizontal)
                ZStack {
                    GridStack(rows: 9, columns: 9, content: { (row, col) in
                        HStack(spacing: 0) {
                            VStack(spacing: 0) {
                                TileView(
                                    tile: sudoku.tiles[row][col],
                                    pressTile: {sudoku.selectTile(row, col)}
                                )
                                .frame(width: tileWidth, height: tileHeight)
                                .border(.placeholder, width: 0.8)
                                if (row == 2 || row == 5) {
                                    Color.primary
                                        .frame(width: tileWidth, height: dividerWidth)
                                }
                            }
                            if (col == 2 || col == 5) {
                                Color.primary
                                    .frame(width: dividerWidth, height: tileHeight)
                            }
                        }
                    })
                    .onAppear {
                        sudoku.startGame()
                    }
                    .blur(radius: sudoku.isLost || sudoku.isSolved ? 5 : 0)
                    if (sudoku.isLost || sudoku.isSolved) {
                        VStack {
                            Text(sudoku.isLost ? "You lost!" : "You won!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(sudoku.isLost ? .red : .green)
                            Button {
                                resetGame()
                            } label: {
                                Text("Start a new one")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .border(.primary, width: dividerWidth)
                
                HStack {
                    VStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.uturn.backward")
                                .font(.system(size: 30))
                        }
                        Text("Undo")
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    VStack {
                        Button {
                            sudoku.eraseTile()
                        } label: {
                            Image(systemName: "eraser")
                                .font(.system(size: 30))
                        }
                        Text("Erase")
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    VStack {
                        Button {
                            sudoku.showHint()
                        } label: {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 30))
                        }
                        .disabled(sudoku.avaliableHints == 0)
                        Text("Hint")
                            .foregroundColor(sudoku.avaliableHints == 0 ? .gray : .accentColor)
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
                        .disabled(sudoku.isLost || sudoku.isSolved)
                    }
                }
                .padding(.horizontal)
            }
           
    }
    
    func resetGame() {
        sudoku = SudokuGenerator(difficulty: Self.difficulty, maxOfMistakes: Self.maxOfMistakes, maxOfHints: Self.maxOfHints)
    }
}

#Preview {
    SudokuView()
}
