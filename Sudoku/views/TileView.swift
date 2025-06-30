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
                if (tile.wrongGuess && tile.isSelected) {
                    Color.red
                } else if (tile.isSelected) {
                    Color("AccentColorLight")
                } else if tile.numberHasErrors {
                    Color(red: 255 / 255, green: 203 / 255, blue: 213 / 255)
                } else if tile.isSameNumberAsSelected {
                    Color("AccentColorLight")
                } else if tile.isTileInGroupSelected {
                    Color("GroupedTileBackground")
                } else {
                    Color("TileBackground")
                }
                if tile.isStatic {
                    Text(String(tile.correctNumber))
                        .font(.title)
                        .foregroundColor(.primary)
                }
                else if let currentNumber = tile.currentNumber {
                    Text(String(currentNumber))
                        .font(.title)
                        .foregroundColor(tile.wrongGuess ? tile.isSelected || tile.isSameNumberAsSelected ? .white : .red : Color("TextColor"))
                }
                else if tile.notes.count > 0 {
                    GridStack(rows: 3, columns: 3, content: { (row, col) in
                        HStack {
                            if tile.notes.contains((row * 3) + col + 1) {
                                Text("\((row * 3) + col + 1)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
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
