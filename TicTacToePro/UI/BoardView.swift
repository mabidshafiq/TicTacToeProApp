//
//  BoardView.swift
//  TicTacToePro
//
//  Created by Muhammad Abid on 26/8/2025.
//

import SwiftUI

struct BoardView: View {
    let board: GameBoard
    let onSquareTap: (Int) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(0..<9, id: \.self) { index in
                SquareView(
                    piece: board[index],
                    position: index,
                    onTap: {
                        onSquareTap(index)
                    }
                )
                .aspectRatio(1.0, contentMode: .fit)
            }
        }
        .padding(20)
        .background(
            ZStack {
                // Outer glow
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: 1)
                
                // Main background with glass effect
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.08))
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            }
        )
    }
}
