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
            Form {
                Section("Game Mode") {
                    Picker("Mode", selection: $engine.selectedMode) {
                        ForEach(GameMode.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: engine.selectedMode) { _, newMode in
                        engine.changeGameMode(newMode)
                    }
                }
                
                if engine.selectedMode == .singlePlayer {
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
                }
                
                Section("Statistics") {
                    HStack {
                        Text(playerXTitle)
                        Spacer()
                        Text("\(playerXWins)")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text(playerOTitle)
                        Spacer()
                        Text("\(playerOWins)")
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        Text("Draws")
                        Spacer()
                        Text("\(draws)")
                            .foregroundColor(.orange)
                    }
                    
                    let totalGames = playerXWins + playerOWins + draws
                    if totalGames > 0 && engine.selectedMode == .singlePlayer {
                        HStack {
                            Text("Win Rate")
                            Spacer()
                            Text("\(Int((Double(playerXWins) / Double(totalGames)) * 100))%")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Section("Actions") {
                    Button("Reset Statistics") {
                        playerXWins = 0
                        playerOWins = 0
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
                        Text("1.1.0")
                            .foregroundColor(.secondary)
                    }
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
    
    private var playerXTitle: String {
        engine.selectedMode == .twoPlayers ? "Player X Wins" : "Games Won"
    }
    
    private var playerOTitle: String {
        engine.selectedMode == .twoPlayers ? "Player O Wins" : "Games Lost"
    }
}
