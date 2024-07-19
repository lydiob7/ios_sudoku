//
//  GridView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import SwiftUI

struct GridStack<Content: View>: View {
    var rows: Int
    var columns: Int
    var content: (Int, Int) -> Content
    
    @ViewBuilder var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<columns, id: \.self) {col in
                        content(row, col)
                    }
                }
            }
        }
    }
}
