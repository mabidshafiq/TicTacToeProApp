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
    @AppStorage("playerWins") private var playerWins = 0
    @AppStorage("computerWins") private var computerWins = 0
    @AppStorage("draws") private var draws = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section("Difficulty Level") {
                    ForEach(TicTacEngine.Difficulty.allCases, id: \.self) { difficulty in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(difficulty.rawValue)
                                    .font(.headline)
                                Text(difficulty.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if engine.difficulty == difficulty {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            engine.changeDifficulty(difficulty)
                        }
                    }
                }
                
                Section("Statistics") {
                    HStack {
                        Text("Games Won")
                        Spacer()
                        Text("\(playerWins)")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Games Lost")
                        Spacer()
                        Text("\(computerWins)")
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        Text("Draws")
                        Spacer()
                        Text("\(draws)")
                            .foregroundColor(.orange)
                    }
                    
                    let totalGames = playerWins + computerWins + draws
                    if totalGames > 0 {
                        HStack {
                            Text("Win Rate")
                            Spacer()
                            Text("\(Int((Double(playerWins) / Double(totalGames)) * 100))%")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Section("Actions") {
                    Button("Reset Statistics") {
                        playerWins = 0
                        computerWins = 0
                        draws = 0
                    }
                    .foregroundColor(.red)
                    
                    Button("New Game") {
                        engine.resetGame()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How to Play")
                            .font(.headline)
                        Text("• Tap any empty square to place your X")
                        Text("• Get three in a row to win")
                        Text("• Choose difficulty to match your skill")
                        Text("• Unbeatable mode uses perfect AI")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
