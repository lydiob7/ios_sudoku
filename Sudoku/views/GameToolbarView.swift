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
                Text("Mistakes")
                Text("\(sudoku.errorsCount) / \(maxOfMistakes)")
            }
            Spacer()
            VStack {
                Text("Level")
                Text("\(difficulty.description)")
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
    }
}
