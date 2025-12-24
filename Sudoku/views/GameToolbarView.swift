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
//  GameToolbar.swift
//  Sudoku
//
//  Created by Tomi Scattini on 07/08/2024.
//

import SwiftUI

struct GameToolbarView: View {
    @Binding var sudoku: Sudoku
    let maxOfMistakes: Int
    let difficulty: Difficulty
    
    var body: some View {
        HStack {
            VStack {
                Text("mistakes")
                Text("\(sudoku.errorsCount) / \(maxOfMistakes)")
            }
            Spacer()
            VStack {
                Text("level")
                Text(difficulty.description)
            }
            Spacer()
            VStack {
                Text("score")
                Text("\(sudoku.score)")
            }
            Spacer()
            VStack {
                Text("time")
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
    }
}
