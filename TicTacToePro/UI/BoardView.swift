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
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 4) {
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
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}
