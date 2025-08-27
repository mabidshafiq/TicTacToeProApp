//
//  TicTacToeProTests.swift
//  TicTacToeProTests
//
//  Created by Muhammad Abid on 26/8/2025.
//

import Testing
@testable import TicTacToePro

struct TicTacToeProTests {
    var engine = TicTacEngine()
    
    @Test func testInitialState() {
        #expect(self.engine.currentPlayer == .x)
        #expect(self.engine.gameResult == .ongoing)
       // #expect(self.engine.board.isEmpty)
    }
    
    @Test func testPlayerMove() {
        engine.makeMove(at: 0)
        #expect(self.engine.board[0, 0] == .x)
        #expect(self.engine.currentPlayer == .o) // AI moves instantly in tests
    }
    
    @Test func testResetGame() {
        engine.makeMove(at: 0)
        engine.resetGame()
       // #expect(self.engine.board.isEmpty)
        #expect(self.engine.currentPlayer == .x)
        #expect(self.engine.gameResult == .ongoing)
    }
    
    @Test func testWinCondition() {
        engine.board.place(.x, at: 0)
        engine.board.place(.x, at: 1)
        engine.board.place(.x, at: 2)
        let result = engine.evaluateBoard(engine.board)
        #expect(result == .win(.x))
    }
    
    @Test func testDrawCondition() {
        engine.board.place(.x, at: 0)
        engine.board.place(.o, at: 1)
        engine.board.place(.x, at: 2)
        engine.board.place(.x, at: 3)
        engine.board.place(.o, at: 4)
        engine.board.place(.x, at: 5)
        engine.board.place(.o, at: 6)
        engine.board.place(.x, at: 7)
        engine.board.place(.o, at: 8)
        let result = engine.evaluateBoard(engine.board)
        #expect(result == .draw)
    }
    
    @Test func testTwoPlayerAlternateTurns() {
        engine.changeGameMode(.twoPlayers)
        
        // Player X move
        engine.makeMove(at: 0)
        #expect(self.engine.board[0, 0] == .x)
        #expect(self.engine.currentPlayer == .o)
        
        // Player O move
        engine.makeMove(at: 1)
        #expect(self.engine.board[1, 1] == .o)
        #expect(self.engine.currentPlayer == .x)
        
        // Player X move again
        engine.makeMove(at: 2)
        #expect(self.engine.board[2, 2] == .x)
        #expect(self.engine.currentPlayer == .o)
    }
    
    @Test func testTwoPlayerWinCondition() {
        engine.changeGameMode(.twoPlayers)
        
        engine.makeMove(at: 0) // X
        engine.makeMove(at: 3) // O
        engine.makeMove(at: 1) // X
        engine.makeMove(at: 4) // O
        engine.makeMove(at: 6) // X
        engine.makeMove(at: 5) // O wins
        
        #expect(self.engine.gameResult == .win(.o))
    }
}
