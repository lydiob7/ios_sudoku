//
//  Sudoku.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import Foundation

final class SavedSudoku: Codable {
    var availableHints: Int
    var currentState: [[Int]]
    var difficulty: Difficulty?
    var errorsCount: Int
    var history: [[[Int]]]
    var initialState: [[Int]]
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
        self.maxOfHints = maxOfHints
        self.maxOfMistakes = maxOfMistakes
        self.score = score
        self.solution = solution
        self.time = time
    }
}

struct Sudoku {
    let solution: [[Int]]
    let initialState: [[Int]]
    let maxOfMistakes: Int
    
    var history: [[[Int]]]
    var errorsCount: Int = 0
    var availableHints: Int
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
        self.availableHints = maxOfHints
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
    
    init(_ savedSudoku: SavedSudoku) {
        self.availableHints = savedSudoku.availableHints
        self.errorsCount = savedSudoku.errorsCount
        self.history = savedSudoku.history
        self.initialState = savedSudoku.initialState
        self.maxOfMistakes = savedSudoku.maxOfMistakes
        self.solution = savedSudoku.solution
        self.tiles = (0..<9).map { row in
            return (0..<9).map { col in
                return Tile(
                    column: col,
                    row: row,
                    number: savedSudoku.solution[row][col],
                    isStatic: savedSudoku.initialState[row][col] != 0,
                    numbersWithErrors: [:],
                    currentNumber: savedSudoku.currentState[row][col] == 0 ? nil : savedSudoku.currentState[row][col]
                )
            }
        }
        self.timer.timeElapsed = savedSudoku.time
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
            if tiles[selectedTile.row][selectedTile.column].isStatic { return }
            let previousGuess = tiles[selectedTile.row][selectedTile.column].currentNumber
            if previousGuess == guessNumber { return }
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
        if availableHints == 0 { return }
        if let selectedTile {
            tiles[selectedTile.row][selectedTile.column].showCorrectNumber()
            addHistory(selectedTile.row, selectedTile.column, tiles[selectedTile.row][selectedTile.column].correctNumber)
            availableHints -= 1
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
        if isPaused {
            timer.stop()
        }
        else {
            timer.resume()
        }
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
