//
//  TileView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import SwiftUI

struct TileView: View {
    let tile: Tile
    let pressTile: () -> ()
    
    var body: some View {
        Button(action: {pressTile()}) {
            ZStack {
                if (tile.isSelected) {
                    Color(red: 178 / 255, green: 223 / 255, blue: 254 / 255)
                } else if tile.numberHasErrors {
                    Color(red: 255 / 255, green: 203 / 255, blue: 213 / 255)
                } else if tile.isSameNumberAsSelected {
                    Color(red: 196 / 255, green: 215 / 255, blue: 234 / 255)
                } else if tile.isTileInGroupSelected {
                    Color(red: 227 / 255, green: 235 / 255, blue: 243 / 255)
                } else {
                    Color.clear
                }
                if tile.isStatic {
                    Text(String(tile.correctNumber))
                        .font(.title)
                        .foregroundColor(.primary)
                }
                else if let currentNumber = tile.currentNumber {
                    Text(String(currentNumber))
                        .font(.title)
                        .foregroundColor(tile.wrongGuess ? .red : .accentColor)
                }
                else if tile.notes.count > 0 {
                    GridStack(rows: 3, columns: 3, content: { (row, col) in
                        HStack {
                            if tile.notes.contains((row * 3) + col + 1) {
                                Text("\((row * 3) + col + 1)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: 12)
                            }
                            else {
                                Color.clear
                                    .frame(maxWidth: 12, maxHeight: 12)
                            }
                        }
                    })
                }
            }
        }
    }
}
