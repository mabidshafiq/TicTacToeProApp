//
//  ControlsBar.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import SwiftUI

struct ControlsBar: View {
    let onNewGame: () -> Void
    let onSettings: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button("New Game") {
                onNewGame()
            }
            .buttonStyle(GameButtonStyle(color: .blue))
            
            Button("Settings") {
                onSettings()
            }
            .buttonStyle(GameButtonStyle(color: .gray))
        }
    }
}

struct GameButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(minWidth: 120, minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(color)
                    .shadow(color: color.opacity(0.3), radius: configuration.isPressed ? 2 : 6, y: configuration.isPressed ? 1 : 3)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
