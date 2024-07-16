//
//  ContentView.swift
//  Sudoku
//
//  Created by Tomi Scattini on 16/07/2024.
//

import SwiftUI

struct Sudoku {
    let solution: [[Int]]
    let initialState: [[Int]]
    let maxOfMistakes: Int
    
    var errorsCount: Int = 0
    var isSolved: Bool {
        solution == initialState
    }
    var isLost: Bool {
        errorsCount >= maxOfMistakes
    }
    var score: Int = 0
    
    var tiles: [[Tile]]
    var selectedTile: Tile?
    
    init(solution: [[Int]], initialState: [[Int]], maxOfMistakes: Int = 3) {
        self.initialState = initialState
        self.solution = solution
       self.maxOfMistakes = maxOfMistakes
        self.tiles = (0..<9).map { row in
            return (0..<9).map { col in
                return Tile(
                    column: col,
                    row: row,
                    number: solution[row][col],
                    isStatic: initialState[row][col] != 0,
                    numbersWithErrors: [:]
                )
            }
        }
    }
    
    mutating func clearPreviousState() {
        if let selectedTile {
            tiles[selectedTile.row][selectedTile.column].deselect()
        }
        
        for (index, r) in tiles.enumerated() {
            for (colIndex, _) in r.enumerated() {
                tiles[index][colIndex].unsetIsSameNumberAsSelected()
                tiles[index][colIndex].groupDeselect()
            }
        }
    }
    
    mutating func selectTile(_ row: Int, _ col: Int) {
        clearPreviousState()
        
        selectedTile = tiles[row][col]
        tiles[row][col].select()
        
        for (index, r) in tiles.enumerated() {
            for (colIndex, tile) in r.enumerated() {
                if tile.column == selectedTile?.column || tile.row == selectedTile?.row || tile.square == selectedTile?.square { tiles[index][colIndex].groupSelect() }
                
                if tile.isStatic && tile.currentNumber == tiles[row][col].currentNumber  { tiles[index][colIndex].setIsSameNumberAsSelected() }
                
            }
        }
    }
    
    mutating func selectAllOfTheSameNumber(_ row: Int, _ col: Int) {
        if let selectedTile {
            for (index, r) in tiles.enumerated() {
                for (colIndex, tile) in r.enumerated() {
                    if tile.isStatic && tile.currentNumber == selectedTile.currentNumber  { tiles[index][colIndex].setIsSameNumberAsSelected() }
                    
                }
            }
        }
    }
    
    mutating func toggleAllTilesWithSameNumberError(_ number: Int, _ set: Bool) {
        for (index, r) in tiles.enumerated() {
            for (colIndex, tile) in r.enumerated() {
                if tile.currentNumber == number  {
                    if set == true { tiles[index][colIndex].setNumberHasErrors() }
                    else { tiles[index][colIndex].unsetNumberHasErrors() }
                }
                else { tiles[index][colIndex].unsetNumberHasErrors() }
            }
        }
    }
    
    mutating func guess(_ guessNumber: Int) {
        if isLost { return }
        if let selectedTile {
            let previousGuess = tiles[selectedTile.row][selectedTile.column].currentNumber
            tiles[selectedTile.row][selectedTile.column].guess(number: guessNumber)
            if tiles[selectedTile.row][selectedTile.column].correctNumber != guessNumber {
                errorsCount += 1
                if let previousGuess { toggleAllTilesWithSameNumberError(previousGuess, false) }
                toggleAllTilesWithSameNumberError(guessNumber, true)
            }
            else if let previousGuess { toggleAllTilesWithSameNumberError(previousGuess, false) }
        }
    }
}

struct Tile {
    public let column: Int
    public let row: Int
    
    public var square: Int {
        if (column >= 0 && column < 3) {
            if (row >= 0 && row < 3) { return 0 }
            else if (row >= 3 && row < 6) { return 3 }
            else { return 6 }
        }
        else if (column >= 3 && column < 6) {
            if (row >= 0 && row < 3) { return 1 }
            else if (row >= 3 && row < 6) { return 4 }
            else { return 7 }
        } else {
            if (row >= 0 && row < 3) { return 2 }
            else if (row >= 3 && row < 6) { return 5 }
            else { return 8 }
        }
    }
    
    public let correctNumber: Int
    public let isStatic: Bool
    
    public var currentNumber: Int?
    public var isSameNumberAsSelected: Bool = false
    public var isSelected: Bool = false
    public var isTileInGroupSelected: Bool = false
    
    public var wrongGuess: Bool {
        if let currentNumber {
            currentNumber != correctNumber
        } else { false }
    }
    var numberHasErrors: Bool = false
    
    init(column: Int, row: Int, number: Int, isStatic: Bool, numbersWithErrors: [Int: Bool]) {
        self.column = column
        self.row = row
        self.correctNumber = number
        self.isStatic = isStatic
        if isStatic {
            self.currentNumber = number
        }
    }
    
    mutating func select() {
        self.isSelected = true
    }
    
    mutating func deselect() {
        self.isSelected = false
    }
    
    mutating func groupSelect() {
        self.isTileInGroupSelected = true
    }
    
    mutating func groupDeselect() {
        self.isTileInGroupSelected = false
    }
    
    mutating func guess(number: Int) {
        self.currentNumber = number
    }
    
    mutating func setIsSameNumberAsSelected() {
        self.isSameNumberAsSelected = true
    }
    
    mutating func unsetIsSameNumberAsSelected() {
        self.isSameNumberAsSelected = false
    }
    
    mutating func setNumberHasErrors() {
        self.numberHasErrors = true
    }
    
    mutating func unsetNumberHasErrors() {
        self.numberHasErrors = false
    }
}

struct TileUI: View {
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
            }
        }
    }
}

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

struct SudokuGrid: View {
    @State public var sudoku: Sudoku
    let tileWidth: CGFloat = 40
    let tileHeight: CGFloat = 49
    let dividerWidth: CGFloat = 3
    
    @ViewBuilder var body: some View {
        VStack(spacing: 30) {
            HStack {
                VStack {
                    Text("Mistakes")
                    Text("\(sudoku.errorsCount) / 3")
                }
                Spacer()
                VStack {
                    Text("Score")
                    Text("\(sudoku.score)")
                }
            }
            .padding(.horizontal)
            GridStack(rows: 9, columns: 9, content: { (row, col) in
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        TileUI(
                            tile: sudoku.tiles[row][col],
                            pressTile: {sudoku.selectTile(row, col)}
                        )
                        .frame(width: tileWidth, height: tileHeight)
                        .border(.placeholder, width: 0.8)
                        if (row == 2 || row == 5) {
                            Color.primary
                                .frame(width: tileWidth, height: dividerWidth)
                        }
                    }
                    if (col == 2 || col == 5) {
                        Color.primary
                            .frame(width: dividerWidth, height: tileHeight)
                    }
                }
            })
            .border(.primary, width: dividerWidth)
            
            HStack {
                ForEach(0..<9) { num in
                    Button(String(num + 1)) {
                        sudoku.guess(num + 1)
                    }
                    .foregroundColor(.accentColor)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(width: 33, height: 50)
                    .disabled(sudoku.isLost || sudoku.isSolved)
                }
            }
        }
    }
}

let exampleSudoku = Sudoku(solution: [
        [9,6,2,4,1,5,3,7,8],
        [3,7,4,9,2,8,5,6,1],
        [1,8,5,7,6,3,4,2,9],
        [5,3,1,6,7,2,9,8,4],
        [6,4,9,8,3,1,2,5,7],
        [8,2,7,5,4,9,6,1,3],
        [7,5,3,2,8,4,1,9,6],
        [4,9,6,1,5,7,8,3,2],
        [2,1,8,3,9,6,7,4,5]
    ], initialState: [
        [0,0,0,0,0,0,3,7,0],
        [0,0,0,9,0,8,0,0,1],
        [1,8,5,0,0,3,0,2,0],
        [5,3,0,0,7,2,9,8,0],
        [0,4,9,8,0,1,0,5,7],
        [8,0,0,0,4,9,6,1,3],
        [7,0,3,0,0,4,0,0,6],
        [4,9,0,0,0,0,8,0,0],
        [0,0,0,3,0,6,0,0,0]
    ])

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SudokuGrid(sudoku: exampleSudoku)
                .navigationTitle("Sudoku")
        }
    }
}

#Preview {
    ContentView()
}
