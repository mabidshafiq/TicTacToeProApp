////
////  ContentView.swift
////  TicTacToePro
////
////  Created by Muhammad Abid on 26/8/2025.
////
//

import SwiftUI

struct ContentView: View {
    @StateObject private var engine = TicTacEngine()
    @StateObject private var haptics = Haptics()
    @State private var showSettings = false
    @AppStorage("playerXWins") private var playerXWins = 0
    @AppStorage("playerOWins") private var playerOWins = 0
    @AppStorage("draws") private var draws = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
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
                    
                    // Floating particles effect
                    ForEach(0..<15, id: \.self) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: CGFloat.random(in: 2...8))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                Animation.easeInOut(duration: Double.random(in: 3...8))
                                    .repeatForever(autoreverses: true),
                                value: UUID()
                            )
                    }
                    
                    VStack(spacing: 10) {
                        // Enhanced Header with fixed sizing
                        VStack(spacing: 5) {
                            Text("Tic Tac Toe Pro")
                                .font(.system(size: 34, weight: .heavy, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.cyan, Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            // Enhanced Score Cards with fixed sizing
                            HStack(spacing: 20) {
                                EnhancedScoreView(
                                    title: scoreTitle(for: .x),
                                    score: playerXWins,
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    icon: "person.fill"
                                )
                                
                                EnhancedScoreView(
                                    title: "Draws",
                                    score: draws,
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    icon: "equal.circle.fill"
                                )
                                
                                EnhancedScoreView(
                                    title: scoreTitle(for: .o),
                                    score: playerOWins,
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.pink, Color.red]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    icon: "cpu.fill"
                                )
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        // Enhanced Game status with fixed sizing
                        VStack(spacing: 5) {
                            if engine.gameResult.isGameOver {
                                VStack(spacing: 8) {
                                    Text(engine.gameResult.displayText)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(gameResultGradient)
                                                .shadow(color: gameResultColor.opacity(0.6), radius: 15, x: 0, y: 0)
                                        )
                                        .scaleEffect(1.05)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            } else {
                                Text(turnIndicatorText)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            if engine.selectedMode == .singlePlayer {
                                Text("Difficulty: \(engine.difficulty.rawValue)")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                    )
                            }
                        }
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: engine.gameResult)
                        
                        BoardView(
                            board: engine.board,
                            onSquareTap: { position in
                                engine.makeMove(at: position)
                            }
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: min(geometry.size.width - 40, 300))
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Enhanced Controls with fixed sizing
                        ControlsBar(
                            engine: engine,
                            onNewGame: {
                                engine.resetGame()
                            },
                            onSettings: {
                                showSettings = true
                            }
                        )
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showSettings) {
            SettingsView(engine: engine)
        }
        .onChange(of: engine.gameResult) { result in
            updateScores(for: result)
            if result.isGameOver {
                haptics.playGameEndFeedback(for: result)
            }
        }
    }
    
    private func scoreTitle(for player: GamePiece) -> String {
        if engine.selectedMode == .twoPlayers {
            return player == .x ? "Player X" : "Player O"
        }
        return player == .x ? "You" : "Computer"
    }
    
    private var turnIndicatorText: String {
        switch engine.selectedMode {
        case .singlePlayer:
            return engine.currentPlayer == .x ? "Your turn" : "Computer thinking..."
        case .twoPlayers:
            return "Player \(engine.currentPlayer.rawValue.uppercased())'s Turn"
        }
    }
    
    private var gameResultColor: Color {
        switch engine.gameResult {
        case .win(let winner):
            return winner == .x ? .blue : .red
        case .draw:
            return .orange
        case .ongoing:
            return .primary
        }
    }
    
    private var gameResultGradient: LinearGradient {
        switch engine.gameResult {
        case .win(let winner):
            if winner == .x {
                return LinearGradient(
                    gradient: Gradient(colors: [Color.cyan, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            } else {
                return LinearGradient(
                    gradient: Gradient(colors: [Color.pink, Color.red]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        case .draw:
            return LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.yellow]),
                startPoint: .leading,
                endPoint: .trailing
            )
        case .ongoing:
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.gray]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    private func updateScores(for result: GameResult) {
        switch result {
        case .win(let winner):
            if winner == .x {
                playerXWins += 1
            } else {
                playerOWins += 1
            }
        case .draw:
            draws += 1
        case .ongoing:
            break
        }
    }
}

struct EnhancedScoreView: View {
    let title: String
    let score: Int
    let gradient: LinearGradient
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text("\(score)")
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.vertical, 4)
        .frame(width: 70, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(gradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ContentView()
}
