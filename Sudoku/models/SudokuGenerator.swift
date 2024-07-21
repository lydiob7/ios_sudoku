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

func SudokuGenerator(difficulty: Difficulty?, maxOfMistakes: Int, maxOfHints: Int) -> Sudoku {
    let seed = [
        [9,6,2,4,1,5,3,7,8],
        [3,7,4,9,2,8,5,6,1],
        [1,8,5,7,6,3,4,2,9],
        [5,3,1,6,7,2,9,8,4],
        [6,4,9,8,3,1,2,5,7],
        [8,2,7,5,4,9,6,1,3],
        [7,5,3,2,8,4,1,9,6],
        [4,9,6,1,5,7,8,3,2],
        [2,1,8,3,9,6,7,4,5]
    ]
    var solution: [[Int]] = seed
    let initialRow = seed[0].shuffled()
    var numbersMap = [Int:Int]()
    
    for i in (0..<9) {
        numbersMap[seed[0][i]] = initialRow[i]
    }
    
    for rowIndex in (0..<9) {
        for numIndex in (0..<9) {
            let originalNumber = seed[rowIndex][numIndex]
            solution[rowIndex][numIndex] = numbersMap[originalNumber] ?? 0
        }
    }
    
    let initialState = leaveOnlyHints(grid: solution, numberOfHints: getNumberOfClues(difficulty: difficulty))
    
    
    return Sudoku(
                solution: solution,
                initialState: initialState,
                maxOfMistakes: maxOfMistakes,
                maxOfHints: maxOfHints
    )
    
}
