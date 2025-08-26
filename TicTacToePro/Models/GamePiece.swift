//
//  GamePiece.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import Foundation

/// Represents a piece on the tic-tac-toe board
enum GamePiece: String, CaseIterable, Codable {
    case empty = ""
    case x = "X"
    case o = "O"
    
    var symbol: String {
        return self.rawValue
    }
    
    var opponent: GamePiece {
        switch self {
        case .x: return .o
        case .o: return .x
        case .empty: return .empty
        }
    }
    
    var isPlayer: Bool {
        return self == .x
    }
    
    var isComputer: Bool {
        return self == .o
    }
}
