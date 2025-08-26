//
//  TicTacEngine.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import Foundation

/// Game engine that manages tic-tac-toe game logic and state
class TicTacEngine: ObservableObject {
    @Published var board = GameBoard()
    @Published var currentPlayer: GamePiece = .x
    @Published var gameResult: GameResult = .ongoing
    @Published var difficulty: Difficulty = .normal
    
    private let ai = MinimaxAI()
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case normal = "Normal"
        case unbeatable = "Unbeatable"
        
        var description: String {
            switch self {
            case .easy:
                return "Easy - Computer makes mistakes"
            case .normal:
                return "Normal - Balanced gameplay"
            case .unbeatable:
                return "Unbeatable - Perfect AI"
            }
        }
    }
    
    init() {
        loadGameState()
    }
    
    /// Makes a move at the specified position
    func makeMove(at position: Int) {
        guard gameResult.isGameOver == false,
              currentPlayer == .x,
              board.canPlaceAt(position) else { return }
        
        // Player move
        board.place(.x, at: position)
        checkGameResult()
        
        if !gameResult.isGameOver {
            nextTurn()
            saveGameState()
            
            // Computer move with delay for better UX
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.makeComputerMove()
            }
        } else {
            saveGameState()
        }
    }
    
    /// Makes the computer move based on current difficulty
    private func makeComputerMove() {
        guard gameResult.isGameOver == false,
              currentPlayer == .o else { return }
        
        let move = ai.getBestMove(for: board, player: .o, difficulty: difficulty)
        
        if let move = move {
            board.place(.o, at: move)
            checkGameResult()
            
            if !gameResult.isGameOver {
                nextTurn()
            }
            saveGameState()
        }
    }
    
    /// Checks for win conditions or draw
    private func checkGameResult() {
        gameResult = evaluateBoard(board)
    }
    
    /// Evaluates the current board state
    func evaluateBoard(_ board: GameBoard) -> GameResult {
        // Check rows
        for row in 0..<3 {
            if board[row, 0] != .empty &&
               board[row, 0] == board[row, 1] &&
               board[row, 1] == board[row, 2] {
                return .win(board[row, 0])
            }
        }
        
        // Check columns
        for col in 0..<3 {
            if board[0, col] != .empty &&
               board[0, col] == board[1, col] &&
               board[1, col] == board[2, col] {
                return .win(board[0, col])
            }
        }
        
        // Check diagonals
        if board[0, 0] != .empty &&
           board[0, 0] == board[1, 1] &&
           board[1, 1] == board[2, 2] {
            return .win(board[0, 0])
        }
        
        if board[0, 2] != .empty &&
           board[0, 2] == board[1, 1] &&
           board[1, 1] == board[2, 0] {
            return .win(board[0, 2])
        }
        
        // Check for draw
        if board.isFull {
            return .draw
        }
        
        return .ongoing
    }
    
    /// Advances to the next turn
    private func nextTurn() {
        currentPlayer = currentPlayer.opponent
    }
    
    /// Resets the game to initial state
    func resetGame() {
        board.reset()
        currentPlayer = .x
        gameResult = .ongoing
        saveGameState()
    }
    
    /// Changes the difficulty level
    func changeDifficulty(_ newDifficulty: Difficulty) {
        difficulty = newDifficulty
        UserDefaults.standard.set(newDifficulty.rawValue, forKey: "GameDifficulty")
    }
    
    // MARK: - Persistence
    
    private func saveGameState() {
        if let data = try? JSONEncoder().encode(board) {
            UserDefaults.standard.set(data, forKey: "SavedBoard")
        }
        UserDefaults.standard.set(currentPlayer.rawValue, forKey: "CurrentPlayer")
        UserDefaults.standard.set(gameResult == .ongoing, forKey: "GameOngoing")
    }
    
    private func loadGameState() {
        // Load difficulty
        if let savedDifficulty = UserDefaults.standard.object(forKey: "GameDifficulty") as? String,
           let difficulty = Difficulty(rawValue: savedDifficulty) {
            self.difficulty = difficulty
        }
        
        // Load game state only if the game was ongoing
        guard UserDefaults.standard.bool(forKey: "GameOngoing") else { return }
        
        // Load board
        if let data = UserDefaults.standard.data(forKey: "SavedBoard"),
           let savedBoard = try? JSONDecoder().decode(GameBoard.self, from: data) {
            self.board = savedBoard
        }
        
        // Load current player
        if let playerString = UserDefaults.standard.object(forKey: "CurrentPlayer") as? String,
           let player = GamePiece(rawValue: playerString) {
            self.currentPlayer = player
        }
        
        // Re-evaluate game result
        checkGameResult()
        
        // If it's computer's turn and game is ongoing, make computer move
        if currentPlayer == .o && !gameResult.isGameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.makeComputerMove()
            }
        }
    }
}
