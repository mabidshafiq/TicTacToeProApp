//
//  GameBoard.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import Foundation

/// Represents the 3x3 tic-tac-toe board
struct GameBoard: Codable, Equatable {
    private var squares: [GamePiece]
    
    init() {
        self.squares = Array(repeating: .empty, count: 9)
    }
    
    init(squares: [GamePiece]) {
        precondition(squares.count == 9, "Board must have exactly 9 squares")
        self.squares = squares
    }
    
    /// Gets the piece at the specified position (0-8)
    subscript(index: Int) -> GamePiece {
        get {
            guard index >= 0 && index < 9 else { return .empty }
            return squares[index]
        }
        set {
            guard index >= 0 && index < 9 else { return }
            squares[index] = newValue
        }
    }
    
    /// Gets the piece at row, column (0-based)
    subscript(row: Int, col: Int) -> GamePiece {
        get {
            let index = row * 3 + col
            return self[index]
        }
        set {
            let index = row * 3 + col
            self[index] = newValue
        }
    }
    
    /// Returns all empty positions on the board
    var emptyPositions: [Int] {
        return squares.enumerated().compactMap { index, piece in
            piece == .empty ? index : nil
        }
    }
    
    /// Checks if the board is full
    var isFull: Bool {
        return !squares.contains(.empty)
    }
    
    /// Checks if the specified position is valid and empty
    func canPlaceAt(_ index: Int) -> Bool {
        return index >= 0 && index < 9 && squares[index] == .empty
    }
    
    /// Places a piece at the specified position
    mutating func place(_ piece: GamePiece, at index: Int) -> Bool {
        guard canPlaceAt(index) else { return false }
        squares[index] = piece
        return true
    }
    
    /// Creates a copy of the board with a piece placed at the specified position
    func placing(_ piece: GamePiece, at index: Int) -> GameBoard? {
        guard canPlaceAt(index) else { return nil }
        var newBoard = self
        newBoard.squares[index] = piece
        return newBoard
    }
    
    /// Resets the board to empty state
    mutating func reset() {
        squares = Array(repeating: .empty, count: 9)
    }
    
    /// Returns the raw squares array for testing purposes
    var rawSquares: [GamePiece] {
        return squares
    }
}
