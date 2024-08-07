//
//  SudokuView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import SwiftUI

let SAVED_SUDOKU_KEY = "CurrentSudoku"

struct SudokuView: View {
    static var difficulty: Difficulty = .hard
    static var maxOfMistakes: Int = 3
    static var maxOfHints: Int = 1
    
    @State var sudoku: Sudoku {
        didSet {
            if let encoded = try? JSONEncoder().encode(toSavedSudoku(sudoku: sudoku, difficulty: Self.difficulty, maxOfMistakes: Self.maxOfMistakes, maxOfHints: Self.maxOfHints)) {
                UserDefaults.standard.set(encoded, forKey: SAVED_SUDOKU_KEY)
            }
        }
    }
    let tileWidth: CGFloat = 40
    let tileHeight: CGFloat = 49
    let dividerWidth: CGFloat = 3
    var isGameBlocked: Bool {
        sudoku.isPaused || sudoku.isLost || sudoku.isSolved
    }
    
    init() {
        if let savedSudoku = UserDefaults.standard.data(forKey: SAVED_SUDOKU_KEY) {
            if let decodedSudoku = try? JSONDecoder().decode(SavedSudoku.self, from: savedSudoku) {
                self.sudoku = Sudoku(decodedSudoku)
                if let difficulty = decodedSudoku.difficulty {
                    Self.difficulty = difficulty
                }
                Self.maxOfHints = decodedSudoku.maxOfHints
                Self.maxOfMistakes = decodedSudoku.maxOfMistakes
                return
            }
        }
        self.sudoku = SudokuGenerator(difficulty: Self.difficulty, maxOfMistakes: Self.maxOfMistakes, maxOfHints: Self.maxOfHints)
    }
    
    @ViewBuilder var body: some View {
            VStack(spacing: 30) {
                GameToolbarView(sudoku: $sudoku, maxOfMistakes: Self.maxOfMistakes, difficulty: Self.difficulty)
                ZStack {
                    GridStack(rows: 9, columns: 9, content: { (row, col) in
                        HStack(spacing: 0) {
                            VStack(spacing: 0) {
                                TileView(
                                    tile: sudoku.tiles[row][col],
                                    pressTile: {
                                        if isGameBlocked { return }
                                        sudoku.selectTile(row, col)
                                    }
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
                
                GameControlsView(sudoku: $sudoku, isGameBlocked: isGameBlocked)
            }
           
    }
    
    func resetGame() {
        sudoku = SudokuGenerator(difficulty: Self.difficulty, maxOfMistakes: Self.maxOfMistakes, maxOfHints: Self.maxOfHints)
        sudoku.startGame()
    }
}

func toSavedSudoku(sudoku: Sudoku, difficulty: Difficulty, maxOfMistakes: Int, maxOfHints: Int) -> SavedSudoku {
    return SavedSudoku(
        availableHints: sudoku.availableHints,
        currentState: sudoku.currentState,
        difficulty: difficulty,
        errorsCount: sudoku.errorsCount,
        history: sudoku.history,
        initialState: sudoku.initialState,
        maxOfMistakes: maxOfMistakes, 
        maxOfHints: maxOfHints, 
        score: sudoku.score,
        solution: sudoku.solution,
        time: sudoku.timer.timeElapsed
    )
}

#Preview {
    SudokuView()
}
