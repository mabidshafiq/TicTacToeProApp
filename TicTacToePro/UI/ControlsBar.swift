//
//  ControlsBar.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//
//
import SwiftUI

struct ControlsBar: View {
    @ObservedObject var engine: TicTacEngine
    let onNewGame: () -> Void
    let onSettings: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            // Enhanced Game Mode Picker with fixed sizing
            VStack(spacing: 12) {
                Text("Game Mode")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                
                HStack(spacing: 0) {
                    ForEach(GameMode.allCases, id: \.self) { mode in
                        Button(action: {
                            engine.changeGameMode(mode)
                        }) {
                            Text(mode.rawValue)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(engine.selectedMode == mode ? .white : .white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .frame(height: 44) // Fixed height
                                .background(
                                    ZStack {
                                        if engine.selectedMode == mode {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .shadow(color: .cyan.opacity(0.4), radius: 8, x: 0, y: 4)
                                        }
                                    }
                                )
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: engine.selectedMode)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .frame(height: 40) // Fixed total height
                .padding(.horizontal, 20)
            }
            
            // Enhanced Action Buttons with fixed sizing
            HStack(spacing: 25) {
                EnhancedGameButton(
                    title: "New Game",
                    icon: "play.fill",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [Color.green, Color.cyan]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    action: onNewGame
                )
                
                EnhancedGameButton(
                    title: "Settings",
                    icon: "gearshape.fill",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    action: onSettings
                )
            }
        }
    }
}

struct EnhancedGameButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 40) // Fixed height
            .background(
                ZStack {
                    // Main gradient background
                    RoundedRectangle(cornerRadius: 25)
                        .fill(gradient)
                    
                    // Glass overlay effect
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .padding()
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
