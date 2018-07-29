//
//  Evaluate.swift
//  GO
//
//  Created by Edward Huang on 5/28/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation


/// Scoring capabilities

class Evaluate {
    
    static func gameEnded<T: Board>(_ board: T) -> Bool {
        if let board = board as? GOBoard {
            return board.gameEnded
        } else if let board = board as? ConnectNBoard {
            let n = board.n
            let foo = Analyze.containsFilledBlock(ofSize: n, forPlayer: .white, onGrid: board.grid)
            let bar = Analyze.containsFilledBlock(ofSize: n, forPlayer: .black, onGrid: board.grid)
            
            if foo || bar {
                // Game has ended
                return true
            }
            
            if board.empties.count == 0 {
                return true
            }
            
            return false
        }
        fatalError("Unknown board")
    }
    
    static func score<T: Board>(_ board: T) -> (black: Int, white: Int) {
        if let board = board as? GOBoard {
            return goScore(board)
        } else if let board = board as? ConnectNBoard {
            return connectNScore(board)
        }
        
        fatalError("Unknown board")
    }
    
    
    // MARK: Private
    
    
    
    static private func connectNScore(_ board: ConnectNBoard) -> (black: Int, white: Int) {
        let n = board.n
        var white: Int = 0
        var black: Int = 0
        if Analyze.containsFilledBlock(ofSize: n, forPlayer: .white, onGrid: board.grid) {
            white = 1
        }
        
        if Analyze.containsFilledBlock(ofSize: n, forPlayer: .black, onGrid: board.grid) {
            black = 1
        }
        
        return (black: black, white: white)
    }
    
    
    /// Gives the score of the game to determine the winner. The first index
    /// represents black's score, the second - white's score
    ///
    /// - Returns: scores
    
    static private func goScore(_ board: GOBoard) -> (black: Int, white: Int) {
        let grid = board.grid
        let dimension = board.dimension
        
        // count the number of black and white pieces
        var blacks = 0
        var whites = 0
        for row in grid {
            for point in row {
                if let owner = point {
                    if owner == .white {
                        whites += 1
                    } else {
                        blacks += 1
                    }
                }
            }
        }
        
        // compute the set of empty sets
        var setOfEmptySets = Set<Set<Point>>()
        var visited = Set<Point>()
        for i in 0...dimension-1 {
            for j in 0...dimension-1 {
                let c = Point(i,j)
                if !visited.contains(c) {
                    let emptySet = Analyze.exploreEmpty(grid: grid, point: c)
                    visited.formUnion(emptySet)
                    setOfEmptySets.insert(emptySet)
                }
            }
        }
        
        
        
        var blackEmpties = 0
        var whiteEmpties = 0
        
        
        // count the number of empty spaces surrounded by blacks and whites
        for emptySet in setOfEmptySets {
            var nextToBlack = false
            var nextToWhite = false
            for coor in emptySet {
                let whiteAdjacents = Analyze.explore(grid: grid, point: coor, player: .white)
                if whiteAdjacents.count > 0 { // there is a white piece adjacent to this set, this set does not count
                    nextToWhite = true
                }
                
                let blackAdjacents = Analyze.explore(grid: grid, point: coor, player: .black)
                if blackAdjacents.count > 0 { // there is a black piece adjacent to this set, this set does not count
                    nextToBlack = true
                }
                
                if nextToWhite && nextToBlack {
                    break
                }
            }
            if nextToBlack && !nextToWhite {
                blackEmpties += emptySet.count
            }
            if nextToWhite && !nextToBlack {
                whiteEmpties += emptySet.count
            }
        }
        
        // compute the scores
        
        let whiteScore = whites + whiteEmpties
        let blackScore = blacks + blackEmpties
        
        return (black: blackScore, white: whiteScore)
    }
    
}
