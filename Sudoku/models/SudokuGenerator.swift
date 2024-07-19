//
//  SudokuGenerator.swift
//  Sudoku
//
//  Created by Tomi Scattini on 18/07/2024.
//
import Foundation

enum Difficulty: Codable, Identifiable, CaseIterable {
    case evil, hard, medium, easy
    
    var id: Self {
        self
    }
    var description: String {
        switch self {
        case .evil:
            "Evil"
        case .hard:
            "Hard"
        case .medium:
            "Medium"
        case .easy:
            "Easy"
        }
    }
}

func getCounterSquare(_ square: String) -> String {
    let coords = square.components(separatedBy: ",")

    let counterRow = 8 - (Int(coords[0]) ?? 0)
    let counterCol = 8 - (Int(coords[1]) ?? 0)

    return "\(counterRow),\(counterCol)"
}

func shiftGrid(_ grid: [[Int]]) -> [[Int]] {
    var newGrid = grid
    let xThirds = Int.random(in: 1...3)
    let yThirds = Int.random(in: 1...3)
    
    for _ in (0..<(yThirds * 3)) {
        let lastRow = newGrid.removeLast()
        newGrid.insert(lastRow, at: 0)
    }

    for i in (0..<9) {
        for _ in (0..<(xThirds * 3)) {
            let lastRowNumber = newGrid[i].removeLast()
            newGrid[i].insert(lastRowNumber, at: 0)
        }
    }
    
    return newGrid
}

func leaveOnlyHints(grid: [[Int]], numberOfHints: Int) -> [[Int]] {
    var newGrid: [[Int]] = grid
    let squaresToClearCount = 81 - numberOfHints
    
    var allSquareIndexes: [String] = []
    for row in (0..<9) {
        for col in (0..<9) {
            allSquareIndexes.append("\(row),\(col)")
        }
    }
    
    var squaresToClear: [String] = []
    
    var counter = 0
    while counter < squaresToClearCount {
        let randomSquare = allSquareIndexes.remove(at: .random(in: 0..<allSquareIndexes.count))
        squaresToClear.append(randomSquare)
        counter += 1
        
        if counter == squaresToClearCount { break }
        if randomSquare == "4,4" { continue }

        let counterSquare = getCounterSquare(randomSquare)
        let indexOfCounterSquare = allSquareIndexes.firstIndex{ $0 == counterSquare }

        if let indexOfCounterSquare {
            allSquareIndexes.remove(at: indexOfCounterSquare)
            squaresToClear.append(counterSquare)
            counter += 1
        }
    }
    
    for i in (0..<squaresToClear.count) {
        let coords = squaresToClear[i].components(separatedBy: ",")
        if let row = Int(coords[0]) {
            if let col = Int(coords[1]) {
                newGrid[row][col] = 0
            }
        }
    }
    
    return shiftGrid(newGrid)
}

func getNumberOfClues(difficulty: Difficulty?) -> Int {
    switch difficulty {
    case .evil:
        Int.random(in: 16...18)
    case .hard:
        Int.random(in: 19...26)
    case .medium:
        Int.random(in: 27...35)
    case .easy:
        Int.random(in: 36...45)
    default:
        Int.random(in: 16...45)
    }
}

func SudokuGenerator(difficulty: Difficulty?) -> Sudoku {
    var initialRow: [Int] = []
    var solution: [[Int]] = []
    var numbersForInitialRow = [1,2,3,4,5,6,7,8,9].shuffled()
    
    for _ in (1...9) {
        let newRandomNumber = numbersForInitialRow.removeFirst()
        initialRow.append(newRandomNumber)
    }
    
    var tempRowsArray: [[Int]] = []
    for row in (1..<9) {
        let offsetDigits = initialRow.prefix(row)
        var newRow = initialRow[row...]
        newRow.append(contentsOf: offsetDigits)
        tempRowsArray.append(Array(newRow))
    }
    solution.append(initialRow)
    solution.append(tempRowsArray[2])
    solution.append(tempRowsArray[5])
    solution.append(tempRowsArray[0])
    solution.append(tempRowsArray[3])
    solution.append(tempRowsArray[6])
    solution.append(tempRowsArray[1])
    solution.append(tempRowsArray[4])
    solution.append(tempRowsArray[7])
    
    let initialState = leaveOnlyHints(grid: solution, numberOfHints: getNumberOfClues(difficulty: difficulty))
    
    
    return Sudoku(solution: solution, initialState: initialState)
    
}
