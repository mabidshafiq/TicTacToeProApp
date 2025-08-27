//
//  ContentView.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
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
                VStack(spacing: 20) {
                    // Header with scores
                    VStack(spacing: 8) {
                        Text("TicTacPro")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 30) {
                            ScoreView(title: scoreTitle(for: .x), score: playerXWins, color: .blue)
                            ScoreView(title: "Draws", score: draws, color: .orange)
                            ScoreView(title: scoreTitle(for: .o), score: playerOWins, color: .red)
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
                        
                        if engine.selectedMode == .singlePlayer {
                            Text("Difficulty: \(engine.difficulty.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
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
                        engine: engine,
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
