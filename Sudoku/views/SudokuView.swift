//
//  SudokuView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import SwiftUI

struct SudokuView: View {
    @AppStorage("CURRENT_SUDOKU_ID") var currentSudokuId: String = "no"
    @Environment(\.modelContext) private var modelContext
    
    static var difficulty: Difficulty = .hard
    static var maxOfMistakes: Int = 3
    static var maxOfHints: Int = 1
    
    @State private var sudoku = SudokuGenerator(difficulty: difficulty, maxOfMistakes: maxOfMistakes, maxOfHints: maxOfHints)
    let tileWidth: CGFloat = 40
    let tileHeight: CGFloat = 49
    let dividerWidth: CGFloat = 3
    var isGameBlocked: Bool {
        sudoku.isPaused || sudoku.isLost || sudoku.isSolved
    }
    
    @ViewBuilder var body: some View {
        
            VStack(spacing: 30) {
                HStack {
                    VStack {
                        Text("Mistakes")
                        Text("\(sudoku.errorsCount) / \(Self.maxOfMistakes)")
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
                        Text(sudoku.timer.formattedTime())
                    }
                    Spacer()
                    Button {
                        sudoku.togglePauseResume()
                    } label: {
                        Image(systemName: sudoku.isPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 20))
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
                    .blur(radius: isGameBlocked ? 5 : 0)
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
                    if (sudoku.isPaused) {
                        VStack {
                            Text("Game paused")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Button {
                                sudoku.togglePauseResume()
                            } label: {
                                Text("Resume game")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .border(.primary, width: dividerWidth)
                
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
                            .disabled(sudoku.avaliableHints == 0 || isGameBlocked)
                            
                            if (sudoku.avaliableHints > 0) {
                                Text("\(sudoku.avaliableHints)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 20, maxHeight: 20)
                                    .background(isGameBlocked ? Color.gray : Color.red)
                                    .clipShape(.circle)
                                    .offset(x: 10, y: -14)
                                    
                            }
                        }
                        Text("Hint")
                            .foregroundColor(sudoku.avaliableHints == 0 || isGameBlocked ? .gray : .accentColor)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    ForEach(0..<9) { num in
                        Button(String(num + 1)) {
                            sudoku.guess(num + 1)
                            if !currentSudokuId.isEmpty { return }
                            else {
                                let newHistoricSudoku = HistoricSudoku(
                                    currentState: sudoku.currentState,
                                    difficulty: Self.difficulty,
                                    errorsCount: sudoku.errorsCount,
                                    initialState: sudoku.initialState,
                                    maxOfMistakes: Self.maxOfMistakes,
                                    maxOfHints: Self.maxOfHints,
                                    score: sudoku.score,
                                    solution: sudoku.solution,
                                    time: sudoku.timer.timeElapsed
                                )
                                modelContext.insert(newHistoricSudoku)
                            }
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
    
    func resetGame() {
        sudoku = SudokuGenerator(difficulty: Self.difficulty, maxOfMistakes: Self.maxOfMistakes, maxOfHints: Self.maxOfHints)
    }
}

#Preview {
    SudokuView()
        .modelContainer(for: HistoricSudoku.self, inMemory: true)
}
