//
//  Haptics.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import UIKit

/// Manages haptic feedback for the game
class Haptics: ObservableObject {
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    init() {
        // Prepare generators for better responsiveness
        impactGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    /// Plays haptic feedback when a move is made
    func playMoveFeedback() {
        impactGenerator.impactOccurred()
    }
    
    /// Plays haptic feedback when the game ends
    func playGameEndFeedback(for result: GameResult) {
        switch result {
        case .win(let winner):
            if winner.isPlayer {
                notificationGenerator.notificationOccurred(.success)
            } else {
                notificationGenerator.notificationOccurred(.error)
            }
        case .draw:
            notificationGenerator.notificationOccurred(.warning)
        case .ongoing:
            break
        }
    }
    
    /// Plays light haptic feedback for UI interactions
    func playLightFeedback() {
        let lightGenerator = UIImpactFeedbackGenerator(style: .light)
        lightGenerator.impactOccurred()
    }
}
