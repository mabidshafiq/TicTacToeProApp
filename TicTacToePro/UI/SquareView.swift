//
//  SquareView.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import SwiftUI

struct SquareView: View {
    let piece: GamePiece
    let position: Int
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var showPiece = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 2)
                    )
                
                // Game piece
                if piece != .empty {
                    Text(piece.symbol)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(pieceColor)
                        .scaleEffect(showPiece ? 1.0 : 0.1)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showPiece)
                }
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
        .onChange(of: piece) { newPiece in
            if newPiece != .empty {
                showPiece = true
            } else {
                showPiece = false
            }
        }
        .onAppear {
            showPiece = piece != .empty
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(piece == .empty ? "Tap to place your X" : "")
    }
    
    private var backgroundColor: Color {
        if piece == .empty {
            return Color(.systemBackground)
        } else {
            return piece.isPlayer ? Color.blue.opacity(0.1) : Color.red.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        return Color.secondary.opacity(0.3)
    }
    
    private var pieceColor: Color {
        return piece.isPlayer ? .blue : .red
    }
    
    private var accessibilityLabel: String {
        let row = position / 3 + 1
        let col = position % 3 + 1
        
        if piece == .empty {
            return "Empty square, row \(row), column \(col)"
        } else {
            let player = piece.isPlayer ? "Your X" : "Computer O"
            return "\(player) in row \(row), column \(col)"
        }
    }
}
