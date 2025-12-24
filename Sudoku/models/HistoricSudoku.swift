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
