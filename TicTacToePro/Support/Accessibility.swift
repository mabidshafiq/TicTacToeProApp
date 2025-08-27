//
//  Accessibility.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import SwiftUI

/// Accessibility utilities and helpers
struct AccessibilityHelper {
    
    /// Creates an accessibility label for a board position
    static func boardPositionLabel(for index: Int, piece: GamePiece, mode: GameMode, currentPlayer: GamePiece) -> String {
        let row = index / 3 + 1
        let col = index % 3 + 1
        
        if piece == .empty {
            let turnDescription = (mode == .twoPlayers) ? "Player \(currentPlayer.rawValue.uppercased())" : "Your"
            return "Empty square at row \(row), column \(col). Tap to place \(turnDescription) piece."
        } else {
            let playerDescription = (mode == .twoPlayers) ? "Player \(piece.rawValue.uppercased())" : (piece.isPlayer ? "Your X" : "Computer's O")
            return "\(playerDescription) at row \(row), column \(col)."
        }
    }
    
    /// Creates an accessibility hint for game controls
    static func gameControlHint(for action: String) -> String {
        switch action {
        case "newGame":
            return "Starts a new game and resets the board"
        case "settings":
            return "Opens game settings and statistics"
        default:
            return ""
        }
    }
    
    /// Creates an accessibility announcement for game state changes
    static func gameStateAnnouncement(for result: GameResult, currentPlayer: GamePiece, mode: GameMode) -> String {
        switch result {
        case .ongoing:
            if mode == .singlePlayer {
                return currentPlayer.isPlayer ? "Your turn. Tap an empty square to make your move." : "Computer is thinking."
            } else {
                return "Player \(currentPlayer.rawValue.uppercased())'s turn."
            }
        case .win(let winner):
            if mode == .singlePlayer {
                return winner.isPlayer ? "Congratulations! You won the game!" : "Computer wins this game."
            } else {
                return "Player \(winner.rawValue.uppercased()) wins!"
            }
        case .draw:
            return "The game ended in a draw."
        }
    }
}

/// View modifier for adding accessibility support
struct AccessibilityModifier: ViewModifier {
    let label: String
    let hint: String?
    let value: String?
    
    init(label: String, hint: String? = nil, value: String? = nil) {
        self.label = label
        self.hint = hint
        self.value = value
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
    }
}

extension View {
    /// Adds accessibility support with label, hint, and value
    func accessibilitySupport(label: String, hint: String? = nil, value: String? = nil) -> some View {
        self.modifier(AccessibilityModifier(label: label, hint: hint, value: value))
    }
}
