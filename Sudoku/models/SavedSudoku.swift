//
//  SavedSudoku.swift
//  Sudoku
//
//  Created by Tomi Scattini on 07/08/2024.
//

import Foundation

final class SavedSudoku: Codable {
    var availableHints: Int
    var currentState: [[Int]]
    var difficulty: Difficulty?
    var errorsCount: Int
    var history: [[[Int]]]
    var initialState: [[Int]]
    var isPaused: Bool
    var maxOfHints: Int
    var maxOfMistakes: Int
    var score: Int
    var solution: [[Int]]
    var time: TimeInterval
    
    init(
        availableHints: Int,
        currentState: [[Int]],
        difficulty: Difficulty,
        errorsCount: Int,
        history: [[[Int]]],
        initialState: [[Int]],
        isPaused: Bool,
        maxOfMistakes: Int,
        maxOfHints: Int,
        score: Int,
        solution: [[Int]],
        time: TimeInterval
    ) {
        self.availableHints = availableHints
        self.currentState = currentState
        self.difficulty = difficulty
        self.errorsCount = errorsCount
        self.history = history
        self.initialState = initialState
        self.isPaused = isPaused
        self.maxOfHints = maxOfHints
        self.maxOfMistakes = maxOfMistakes
        self.score = score
        self.solution = solution
        self.time = time
    }
}
