//
//  Untit ContentView led.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var engine = TicTacEngine()
    @StateObject private var haptics = Haptics()
    @State private var showSettings = false
    @AppStorage("playerWins") private var playerWins = 0
    @AppStorage("computerWins") private var computerWins = 0
    @AppStorage("draws") private var draws = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    // Header with scores
                    VStack(spacing: 8) {
                        Text("TicTacPro")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 30) {
                            ScoreView(title: "You", score: playerWins, color: .blue)
                            ScoreView(title: "Draws", score: draws, color: .orange)
                            ScoreView(title: "Computer", score: computerWins, color: .red)
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    // Game status
                    VStack(spacing: 12) {
                        if engine.gameResult.isGameOver {
                            Text(engine.gameResult.displayText)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(gameResultColor)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Text(turnIndicatorText)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Difficulty: \(engine.difficulty.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: engine.gameResult)
                    
                    // Game board
                    BoardView(
                        board: engine.board,
                        onSquareTap: { position in
                            engine.makeMove(at: position)
                        }
                    )
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Controls
                    ControlsBar(
                        onNewGame: {
                            engine.resetGame()
                        },
                        onSettings: {
                            showSettings = true
                        }
                    )
                    .padding(.bottom, 20)
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
    
    private var turnIndicatorText: String {
        if engine.currentPlayer == .x {
            return "Your turn"
        } else {
            return "Computer thinking..."
        }
    }
    
    private var gameResultColor: Color {
        switch engine.gameResult {
        case .win(let winner):
            return winner.isPlayer ? .green : .red
        case .draw:
            return .orange
        case .ongoing:
            return .primary
        }
    }
    
    private func updateScores(for result: GameResult) {
        switch result {
        case .win(let winner):
            if winner.isPlayer {
                playerWins += 1
            } else {
                computerWins += 1
            }
        case .draw:
            draws += 1
        case .ongoing:
            break
        }
    }
}

struct ScoreView: View {
    let title: String
    let score: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(score)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}


#Preview {
    ContentView()
}
