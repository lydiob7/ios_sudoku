//
//  SudokuView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import SwiftUI

struct SudokuView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isVisible = false
    
    let difficulty: Difficulty
    let maxOfMistakes: Int
    let maxOfHints: Int
    let startNew: Bool
    
    @State var sudoku: Sudoku {
        didSet {
            if let encoded = try? JSONEncoder().encode(toSavedSudoku(sudoku: sudoku, difficulty: difficulty, maxOfMistakes: maxOfMistakes, maxOfHints: maxOfHints)) {
                UserDefaults.standard.set(encoded, forKey: SAVED_SUDOKU_KEY)
            }
        }
    }
    let tileWidth: CGFloat = 40
    let tileHeight: CGFloat = 44
    let dividerWidth: CGFloat = 3
    var isGameBlocked: Bool {
        sudoku.isPaused || sudoku.isLost || sudoku.isSolved
    }
    
    init(difficulty: Difficulty = .hard, maxOfMistakes: Int = 3, maxOfHints: Int = 1, startNew: Bool = false) {
        self.difficulty = difficulty
        self.maxOfMistakes = maxOfMistakes
        self.maxOfHints = maxOfHints
        self.startNew = startNew
        
        if !startNew,
           let savedSudoku = UserDefaults.standard.data(forKey: SAVED_SUDOKU_KEY),
           let decodedSudoku = try? JSONDecoder().decode(SavedSudoku.self, from: savedSudoku) {
            _sudoku = State(initialValue: Sudoku(decodedSudoku))
        } else {
            _sudoku = State(initialValue: SudokuGenerator(
                difficulty: difficulty,
                maxOfMistakes: maxOfMistakes,
                maxOfHints: maxOfHints
            ))
        }
    }
    
    @ViewBuilder var body: some View {
            VStack(spacing: 30) {
                GameToolbarView(sudoku: $sudoku, maxOfMistakes: maxOfMistakes, difficulty: difficulty)
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
                                .border(Color("TextColor"), width: 0.8)
                                if (row == 2 || row == 5) {
                                    Color("TextColor")
                                        .frame(width: tileWidth, height: dividerWidth)
                                }
                            }
                            if (col == 2 || col == 5) {
                                Color("TextColor")
                                    .frame(width: dividerWidth, height: tileHeight)
                            }
                        }
                    })
                    .blur(radius: isGameBlocked ? 8 : 0)
                    
                    if (sudoku.isLost || sudoku.isSolved) {
                        VStack(spacing: 20) {
                            Text(sudoku.isLost ? "you_lost" : "you_won")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(sudoku.isLost ? .red : .green)
                            
                            if sudoku.isSolved {
                                Text("score: \(sudoku.score)")
                            }
                            
                            Button {
                                sudoku.reset()
                            } label: {
                                Text("reset_game")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .border(Color.black)
                            }
                            Button {
                                startNewGame()
                            } label: {
                                Text("start_new")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color("AccentColor"))
                                    .border(Color.black)
                            }
                        }
                        .frame(width: 300)
                    }
                    if (sudoku.isPaused) {
                        VStack(spacing: 20) {
                            Text("game_paused")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Button {
                                sudoku.reset()
                            } label: {
                                Text("start_over")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .border(Color.black)
                            }
                                
                            Button {
                                sudoku.togglePauseResume()
                            } label: {
                                Text("resume_game")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color("AccentColor"))
                                    .border(Color.black)
                            }
                              
                        }
                        .frame(width: 300)
                    }
                }
                .border(.primary, width: dividerWidth)
                .sensoryFeedback(.impact(weight: .medium, intensity: 1),trigger: sudoku.hasErrors)
                
                GameControlsView(sudoku: $sudoku, isGameBlocked: isGameBlocked)
            }
            .navigationTitle("app_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Center title (controls color explicitly)
                ToolbarItem(placement: .principal) {
                    Text("app_title")
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
        
            .onAppear {
                isVisible = true
                sudoku.startGameIfNeeded()
            }
            .onDisappear {
                isVisible = false
                sudoku.pauseIfNeeded()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active:
                    if isVisible { sudoku.startGameIfNeeded() }
                case .inactive, .background:
                    sudoku.pauseIfNeeded()
                default:
                    break
                }
            }

    }
    
    func startNewGame() {
        sudoku = SudokuGenerator(difficulty: difficulty, maxOfMistakes: maxOfMistakes, maxOfHints: maxOfHints)
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
        isPaused: sudoku.isPaused,
        maxOfMistakes: maxOfMistakes,
        maxOfHints: maxOfHints, 
        score: sudoku.score,
        solution: sudoku.solution,
        time: sudoku.timer.timeElapsed
    )
}

#Preview {
    ZStack {
        Color("AppBackground")
            .ignoresSafeArea()
        
        SudokuView(startNew: true)
            .foregroundStyle(Color("TextColor"))
    }
}
