//
//  MinimaxAI.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import Foundation

/// AI engine using minimax algorithm with alpha-beta pruning
class MinimaxAI {
    
    /// Gets the best move for the AI based on difficulty level
    func getBestMove(for board: GameBoard, player: GamePiece, difficulty: TicTacEngine.Difficulty) -> Int? {
        let emptyPositions = board.emptyPositions
        guard !emptyPositions.isEmpty else { return nil }
        
        switch difficulty {
        case .easy:
            // 70% chance of random move, 30% chance of best move
            if Double.random(in: 0...1) < 0.7 {
                return emptyPositions.randomElement()
            } else {
                return getBestMoveWithMinimax(board: board, player: player, depth: 2)
            }
            
        case .normal:
            // Use minimax with limited depth
            return getBestMoveWithMinimax(board: board, player: player, depth: 4)
            
        case .unbeatable:
            // Use full minimax search
            return getBestMoveWithMinimax(board: board, player: player, depth: 9)
        }
    }
    
    /// Gets the best move using minimax algorithm with alpha-beta pruning
    private func getBestMoveWithMinimax(board: GameBoard, player: GamePiece, depth: Int) -> Int? {
        var bestMove: Int?
        var bestScore = player == .o ? Int.min : Int.max
        
        for position in board.emptyPositions {
            guard let newBoard = board.placing(player, at: position) else { continue }
            
            let score = minimax(
                board: newBoard,
                depth: depth - 1,
                isMaximizing: player == .x,
                alpha: Int.min,
                beta: Int.max,
                engine: TicTacEngine()
            )
            
            if player == .o { // Computer is maximizing
                if score > bestScore {
                    bestScore = score
                    bestMove = position
                }
            } else { // Player is minimizing
                if score < bestScore {
                    bestScore = score
                    bestMove = position
                }
            }
        }
        
        return bestMove
    }
    
    /// Minimax algorithm with alpha-beta pruning
    private func minimax(
        board: GameBoard,
        depth: Int,
        isMaximizing: Bool,
        alpha: Int,
        beta: Int,
        engine: TicTacEngine
    ) -> Int {
        var alpha = alpha
        var beta = beta
        
        let result = engine.evaluateBoard(board)
        
        // Terminal conditions
        if case .win(let winner) = result {
            return winner == .o ? 10 - (9 - depth) : -10 + (9 - depth) // Prefer faster wins/losses
        } else if result == .draw {
            return 0
        } else if depth == 0 {
            return 0 // Depth limit reached
        }
        
        if isMaximizing {
            var maxScore = Int.min
            
            for position in board.emptyPositions {
                guard let newBoard = board.placing(.o, at: position) else { continue }
                
                let score = minimax(
                    board: newBoard,
                    depth: depth - 1,
                    isMaximizing: false,
                    alpha: alpha,
                    beta: beta,
                    engine: engine
                )
                
                maxScore = max(maxScore, score)
                alpha = max(alpha, score)
                
                if beta <= alpha {
                    break // Beta cutoff
                }
            }
            
            return maxScore
        } else {
            var minScore = Int.max
            
            for position in board.emptyPositions {
                guard let newBoard = board.placing(.x, at: position) else { continue }
                
                let score = minimax(
                    board: newBoard,
                    depth: depth - 1,
                    isMaximizing: true,
                    alpha: alpha,
                    beta: beta,
                    engine: engine
                )
                
                minScore = min(minScore, score)
                beta = min(beta, score)
                
                if beta <= alpha {
                    break // Alpha cutoff
                }
            }
            
            return minScore
        }
    }
}
