// File: README.md
# TicTacPro

A modern, feature-rich Tic-Tac-Toe iOS app built with SwiftUI, featuring an unbeatable AI opponent and multiple difficulty levels.

## Features

### Core Gameplay
- **Single-player mode**: Player (X) vs Computer (O)
- **Three difficulty levels**:
  - **Easy**: Computer makes strategic mistakes (70% random moves)
  - **Normal**: Balanced gameplay with limited-depth minimax (depth 4)
  - **Unbeatable**: Perfect AI using full minimax with alpha-beta pruning

### User Interface
- **Clean, modern SwiftUI design** with light/dark mode support
- **Smooth animations** for piece placement and game state changes
- **Haptic feedback** for moves and game completion
- **Accessibility support** with VoiceOver labels and hints
- **Turn indicators** and real-time game status

### Persistence & Statistics
- **Game state restoration**: Automatically saves and restores the current game
- **Score tracking**: Persistent win/loss/draw statistics using @AppStorage
- **Settings persistence**: Remembers difficulty preference

### Technical Features
- **Minimax AI with alpha-beta pruning** for optimal computer play
- **Clean architecture** with separate Models, Engine, UI, and Support layers
- **Comprehensive unit tests** for game logic and AI behavior
- **No external dependencies** - pure SwiftUI and Swift


## Requirements

- **iOS 17.0+**
- **Swift 5.9+**
- **Xcode 15.0+**

## Installation

1. Create a new iOS project in Xcode
2. Choose "iOS" platform and "App" template
3. Set the interface to "SwiftUI" and lifecycle to "SwiftUI App"
4. Replace the generated files with the provided source files
5. Maintain the folder structure as shown above
6. Build and run

## Game Rules

1. **Objective**: Get three of your pieces (X) in a row horizontally, vertically, or diagonally
2. **Turn order**: Player always goes first with X, computer responds with O
3. **Winning**: First to achieve three in a row wins
4. **Draw**: If the board fills without a winner, the game is a draw

## AI Implementation

The computer opponent uses the **minimax algorithm** with several optimizations:

- **Alpha-beta pruning** for improved performance
- **Depth limiting** for different difficulty levels
- **Move scoring** that prefers faster wins and slower losses
- **Random move injection** on Easy difficulty for more human-like play

### Difficulty Levels

- **Easy (70% random)**: Makes random moves 70% of the time, strategic moves 30%
- **Normal (depth 4)**: Uses minimax with limited search depth
- **Unbeatable (depth 9)**: Searches the complete game tree for perfect play

## Testing

The app includes comprehensive unit tests covering:

- **Game logic validation**: Win detection, move validation, board state
- **AI behavior**: Ensures unbeatable difficulty never loses
- **Edge cases**: Full boards, invalid moves, game state transitions

Run tests in Xcode with `⌘+U` or through the Test Navigator.

## Accessibility

TicTacPro is fully accessible with:

- **VoiceOver support** for all game elements
- **Clear audio descriptions** of board positions and game state
- **Logical navigation order** for screen readers
- **High contrast support** for visual elements

## Privacy

- **No data collection**: All game data stays on device
- **Local storage only**: Uses UserDefaults for game state and statistics
- **No network access**: Fully offline gameplay

## License

This project is provided as educational sample code. Feel free to use and modify for learning purposes.
