//
//  HistoricSudoku.swift
//  Sudoku
//
//  Created by Tomi Scattini on 05/08/2024.
//

import Foundation

final class HistoricSudoku: Identifiable, Codable {
    var difficulty: Difficulty
    var errorsCount: Int
    var id = UUID()
    var isFinished: Bool
    var isWon: Bool
    var maxOfHints: Int
    var maxOfMistakes: Int
    var score: Int
    var time: TimeInterval
    var timestamp = Date()
    
    init(
        difficulty: Difficulty,
        errorsCount: Int,
        isFinished: Bool,
        isWon: Bool,
        maxOfMistakes: Int,
        maxOfHints: Int,
        score: Int,
        time: TimeInterval
    ) {
        self.difficulty = difficulty
        self.errorsCount = errorsCount
        self.isFinished = isFinished
        self.isWon = isWon
        self.maxOfHints = maxOfHints
        self.maxOfMistakes = maxOfMistakes
        self.score = score
        self.time = time
    }
}
