//
//  Tile.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import Foundation

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
    
    public var isStatic: Bool
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
    
    mutating func guess(number: Int?) {
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
    
    mutating func showCorrectNumber() {
        self.isStatic = true
    }
}
