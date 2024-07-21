//
//  Sudoku.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import Foundation

struct Sudoku {
    let solution: [[Int]]
    let initialState: [[Int]]
    let maxOfMistakes: Int
    
    var errorsCount: Int = 0
    var avaliableHints: Int
    var isSolved: Bool {
        solution == tiles.map { row in
            return row.map { tile in
                return tile.currentNumber
            }
        }
    }
    var isLost: Bool {
        errorsCount >= maxOfMistakes
    }
    var score: Int = 0
    static var elapsedTime: Int = 0
    let timer = TimerClock(interval: 1) {
        elapsedTime += 1
    }
    var finishedTime: Int {
        return isLost || isSolved ? Self.elapsedTime : 0
    }
   
    
    var tiles: [[Tile]]
    var selectedTile: Tile?
    
    init(solution: [[Int]], initialState: [[Int]], maxOfMistakes: Int = 3, maxOfHints: Int = 1) {
        self.initialState = initialState
        self.solution = solution
        self.maxOfMistakes = maxOfMistakes
        self.avaliableHints = maxOfHints
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
        Self.elapsedTime = 0
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
    
    mutating func eraseTile() {
        if let selectedTile {
            let previousGuess = tiles[selectedTile.row][selectedTile.column].currentNumber
            tiles[selectedTile.row][selectedTile.column].guess(number: nil)
            if let previousGuess { toggleAllTilesWithSameNumberError(previousGuess, false) }
        }
    }
    
    mutating func showHint() {
        if avaliableHints == 0 { return }
        if let selectedTile {
            tiles[selectedTile.row][selectedTile.column].showCorrectNumber()
            avaliableHints -= 1
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
    
    mutating func startGame() {
        timer.start()
    }
}
