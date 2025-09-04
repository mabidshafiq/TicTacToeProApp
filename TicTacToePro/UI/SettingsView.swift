//
//  SettingsView.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var engine: TicTacEngine
    @Environment(\.dismiss) private var dismiss
    @AppStorage("playerXWins") private var playerXWins = 0
    @AppStorage("playerOWins") private var playerOWins = 0
    @AppStorage("draws") private var draws = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.2),
                        Color(red: 0.2, green: 0.1, blue: 0.3),
                        Color(red: 0.1, green: 0.2, blue: 0.4)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 25) {
                        // Game Mode Section
                        EnhancedSettingsSection(title: "Game Mode", icon: "gamecontroller.fill") {
                            VStack(spacing: 15) {
                                HStack(spacing: 0) {
                                    ForEach(GameMode.allCases, id: \.self) { mode in
                                        Button(action: {
                                            engine.changeGameMode(mode)
                                        }) {
                                            Text(mode.rawValue)
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundColor(engine.selectedMode == mode ? .white : .white.opacity(0.7))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    ZStack {
                                                        if engine.selectedMode == mode {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .fill(
                                                                    LinearGradient(
                                                                        gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                                                        startPoint: .topLeading,
                                                                        endPoint: .bottomTrailing
                                                                    )
                                                                )
                                                                .shadow(color: .cyan.opacity(0.4), radius: 6, x: 0, y: 3)
                                                        }
                                                    }
                                                )
                                        }
                                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: engine.selectedMode)
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        // Difficulty Section
                        if engine.selectedMode == .singlePlayer {
                            EnhancedSettingsSection(title: "Difficulty Level", icon: "brain.head.profile.fill") {
                                VStack(spacing: 12) {
                                    ForEach(TicTacEngine.Difficulty.allCases, id: \.self) { difficulty in
                                        EnhancedDifficultyRow(
                                            difficulty: difficulty,
                                            isSelected: engine.difficulty == difficulty,
                                            onTap: {
                                                engine.changeDifficulty(difficulty)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        
                        // Statistics Section
                        EnhancedSettingsSection(title: "Statistics", icon: "chart.bar.fill") {
                            VStack(spacing: 15) {
                                EnhancedStatRow(
                                    title: playerXTitle,
                                    value: "\(playerXWins)",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                
                                EnhancedStatRow(
                                    title: playerOTitle,
                                    value: "\(playerOWins)",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.pink, Color.red]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                
                                EnhancedStatRow(
                                    title: "Draws",
                                    value: "\(draws)",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                
                                let totalGames = playerXWins + playerOWins + draws
                                if totalGames > 0 && engine.selectedMode == .singlePlayer {
                                    EnhancedStatRow(
                                        title: "Win Rate",
                                        value: "\(Int((Double(playerXWins) / Double(totalGames)) * 100))%",
                                        gradient: LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.mint]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                }
                            }
                        }
                        
                        // Actions Section
                        EnhancedSettingsSection(title: "Actions", icon: "bolt.fill") {
                            VStack(spacing: 15) {
                                EnhancedActionButton(
                                    title: "Reset Statistics",
                                    icon: "trash.fill",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.red, Color.pink]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    action: {
                                        playerXWins = 0
                                        playerOWins = 0
                                        draws = 0
                                    }
                                )
                                
                                EnhancedActionButton(
                                    title: "New Game",
                                    icon: "play.fill",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Color.cyan]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    action: {
                                        engine.resetGame()
                                        dismiss()
                                    }
                                )
                            }
                        }
                        
                        // About Section
                        EnhancedSettingsSection(title: "About", icon: "info.circle.fill") {
                            HStack {
                                Text("Version")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Spacer()
                                
                                Text("1.1.0")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var playerXTitle: String {
        engine.selectedMode == .twoPlayers ? "Player X Wins" : "Games Won"
    }
    
    private var playerOTitle: String {
        engine.selectedMode == .twoPlayers ? "Player O Wins" : "Games Lost"
    }
}

// MARK: - Enhanced Settings Components

struct EnhancedSettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.cyan, Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                content
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
        }
    }
}

struct EnhancedDifficultyRow: View {
    let difficulty: TicTacEngine.Difficulty
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(difficulty.rawValue)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(difficulty.description)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: .cyan.opacity(0.4), radius: 6, x: 0, y: 3)
                }
            }
            .padding(.vertical, 8)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

struct EnhancedStatRow: View {
    let title: String
    let value: String
    let gradient: LinearGradient
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(gradient.opacity(0.3))
                        .overlay(
                            Capsule()
                                .stroke(gradient, lineWidth: 2)
                        )
                )
        }
    }
}

struct EnhancedActionButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(gradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .onTapGesture {
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
}
