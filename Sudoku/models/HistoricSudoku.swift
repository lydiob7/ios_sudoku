//
//  HistoricSudoku.swift
//  Sudoku
//
//  Created by Tomi Scattini on 05/08/2024.
//

import Foundation
import SwiftData

@Model
final class HistoricSudoku {
    var currentState: [[Int]]
    var difficulty: Difficulty?
    var errorsCount: Int
    var initialState: [[Int]]
    var maxOfHints: Int
    var maxOfMistakes: Int
    var score: Int
    var solution: [[Int]]
    var time: TimeInterval
    @Attribute(.unique)
    var timestamp: Date
    
    init(
        currentState: [[Int]],
        difficulty: Difficulty,
        errorsCount: Int,
        initialState: [[Int]],
        maxOfMistakes: Int,
        maxOfHints: Int,
        score: Int,
        solution: [[Int]],
        time: TimeInterval
    ) {
        self.currentState = currentState
        self.difficulty = difficulty
        self.errorsCount = errorsCount
        self.initialState = initialState
        self.maxOfHints = maxOfHints
        self.maxOfMistakes = maxOfMistakes
        self.score = score
        self.solution = solution
        self.time = time
        self.timestamp = Date()
    }
}
