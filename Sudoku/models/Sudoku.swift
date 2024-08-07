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
    
    var history: [[[Int]]]
    var errorsCount: Int = 0
    var avaliableHints: Int
    var isPaused: Bool = false
    var isNotesMode: Bool = false
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
    let timer = TimerClock()
    var finishedTime: String {
        return isLost || isSolved ? timer.formattedTime() : "00:00"
    }
   
    
    var tiles: [[Tile]]
    var selectedTile: Tile?
    
    var currentState: [[Int]] {
        return (0..<9).map { row in
            return (0..<9).map { col in
                if (tiles[row][col].isStatic) { return tiles[row][col].correctNumber }
                else { return tiles[row][col].currentNumber ?? 0 }
            }
        }
    }
    
    init(solution: [[Int]], initialState: [[Int]], maxOfMistakes: Int = 3, maxOfHints: Int = 1) {
        self.initialState = initialState
        self.solution = solution
        self.maxOfMistakes = maxOfMistakes
        self.avaliableHints = maxOfHints
        self.history = [initialState]
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
    
    mutating func addHistory(_ row: Int, _ col: Int, _ value: Int) {
        let newStep = history.last
        if var newStep {
            newStep[row][col] = value
            history.append(newStep)
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
    
    mutating func eraseTile() {
        if let selectedTile {
            let previousGuess = tiles[selectedTile.row][selectedTile.column].currentNumber
            tiles[selectedTile.row][selectedTile.column].guess(number: nil)
            if let previousGuess { toggleAllTilesWithSameNumberError(previousGuess, false) }
        }
    }
    
    mutating func guess(_ guessNumber: Int) {
        if isLost { return }
        if isNotesMode {
            toggleTileNote(guessNumber)
            return
        }
        if let selectedTile {
            let previousGuess = tiles[selectedTile.row][selectedTile.column].currentNumber
            tiles[selectedTile.row][selectedTile.column].guess(number: guessNumber)
            tiles[selectedTile.row][selectedTile.column].resetNotes()
            addHistory(selectedTile.row, selectedTile.column, guessNumber)
            if tiles[selectedTile.row][selectedTile.column].correctNumber != guessNumber {
                errorsCount += 1
                if let previousGuess { toggleAllTilesWithSameNumberError(previousGuess, false) }
                toggleAllTilesWithSameNumberError(guessNumber, true)
            }
            else if let previousGuess { toggleAllTilesWithSameNumberError(previousGuess, false) }
            if isLost || isSolved {
                timer.stop()
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
    
    mutating func showHint() {
        if avaliableHints == 0 { return }
        if let selectedTile {
            tiles[selectedTile.row][selectedTile.column].showCorrectNumber()
            addHistory(selectedTile.row, selectedTile.column, tiles[selectedTile.row][selectedTile.column].correctNumber)
            avaliableHints -= 1
        }
    }
    
    mutating func startGame() {
        timer.start()
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
    
    mutating func toggleNotesMode() {
        isNotesMode = !isNotesMode
    }
    
    mutating func togglePauseResume() {
        isPaused = !isPaused
    }
    
    mutating func toggleTileNote(_ number: Int) {
        if let selectedTile {
            tiles[selectedTile.row][selectedTile.column].toggleNote(number)
        }
    }
    
    mutating func undo() {
        if history.count == 1 { return }
        history.removeLast()
        let previousMove = history.last
        if let previousMove {
            for row in 0..<9 {
                for col in 0..<9 {
                    let oldValue = previousMove[row][col]
                    tiles[row][col].guess(number: oldValue == 0 ? nil : oldValue)
                    toggleAllTilesWithSameNumberError(oldValue, false)
                }
            }
        }
    }
}
