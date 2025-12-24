// This file is part of Sudoku b7.
//
// Copyright (C) 2024 Tomás Scattini
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
