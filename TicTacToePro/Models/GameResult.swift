//
//  GameResult.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import Foundation

/// Represents the result of a tic-tac-toe game
enum GameResult: Equatable {
    case ongoing
    case win(GamePiece)
    case draw
    
    var isGameOver: Bool {
        return self != .ongoing
    }
    
    var winner: GamePiece? {
        if case .win(let piece) = self {
            return piece
        }
        return nil
    }
    
    var isDraw: Bool {
        return self == .draw
    }
    
    var displayText: String {
        switch self {
        case .ongoing:
            return ""
        case .win(let piece):
            if piece.isPlayer {
                return "You Win! 🎉"
            } else {
                return "Computer Wins 🤖"
            }
        case .draw:
            return "It's a Draw! 🤝"
        }
    }
}
