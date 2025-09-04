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
    @State private var pulseAnimation = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background with glass morphism effect
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(borderGradient, lineWidth: 2)
                    )
                    .shadow(color: shadowColor, radius: isPressed ? 4 : 8, x: 0, y: isPressed ? 2 : 4)
                
                // Hover/Active state overlay
                if piece == .empty && pulseAnimation {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                        .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulseAnimation)
                }
                
                // Game piece with enhanced styling
                if piece != .empty {
                    ZStack {
                        // Glow effect behind the symbol
                        Text(piece.symbol)
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(pieceGlowColor)
                            .blur(radius: 8)
                            .scaleEffect(showPiece ? 1.2 : 0.1)
                        
                        // Main symbol
                        Text(piece.symbol)
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(pieceGradient)
                            .scaleEffect(showPiece ? 1.0 : 0.1)
                            .rotationEffect(.degrees(showPiece ? 0 : 180))
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showPiece)
                }
                
                // Empty square indicator
                if piece == .empty {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 8, height: 8)
                        .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                        .opacity(pulseAnimation ? 0.8 : 0.4)
                }
            }
        }
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onTapGesture {
            if piece == .empty {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = false
                    }
                }
            }
        }
        .onChange(of: piece) { newPiece in
            if newPiece != .empty {
                showPiece = true
                pulseAnimation = false
            } else {
                showPiece = false
                pulseAnimation = true
            }
        }
        .onAppear {
            showPiece = piece != .empty
            pulseAnimation = piece == .empty
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(piece == .empty ? "Tap to place your move" : "")
    }
    
    private var backgroundColor: LinearGradient {
        if piece == .empty {
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.white.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            let baseColors = piece.isPlayer ?
                [Color.cyan.opacity(0.2), Color.blue.opacity(0.1)] :
                [Color.pink.opacity(0.2), Color.red.opacity(0.1)]
            
            return LinearGradient(
                gradient: Gradient(colors: baseColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var borderGradient: LinearGradient {
        if piece == .empty {
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.4),
                    Color.white.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            let borderColors = piece.isPlayer ?
                [Color.cyan.opacity(0.6), Color.blue.opacity(0.4)] :
                [Color.pink.opacity(0.6), Color.red.opacity(0.4)]
            
            return LinearGradient(
                gradient: Gradient(colors: borderColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var pieceGradient: LinearGradient {
        let colors = piece.isPlayer ?
            [Color.cyan, Color.blue] :
            [Color.pink, Color.red]
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var pieceGlowColor: Color {
        return piece.isPlayer ? .cyan.opacity(0.6) : .pink.opacity(0.6)
    }
    
    private var shadowColor: Color {
        if piece == .empty {
            return .black.opacity(0.1)
        } else {
            return piece.isPlayer ? .cyan.opacity(0.3) : .pink.opacity(0.3)
        }
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
