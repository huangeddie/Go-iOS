//
//  TicTacToeBoard.swift
//  GO
//
//  Created by Eddie Huang on 3/25/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

public struct ConnectNBoard: Board {
    public var grid: [[Player?]]
    
    public var turn: Player = .black
    
    public var lastPiece: Point? = nil
    
    let n: Int
    
    public var empties: [Point] {
        var ret = [Point]()
        for i in 0..<dimension {
            for j in 0..<dimension {
                if grid[i][j] == nil {
                    let p = Point(i, j)
                    ret.append(p)
                }
            }
        }
        return ret
    }
    
    public init() {
        self.init(dimension: 3, n: 3)
    }
    
    public init(dimension d: Int) {
        let n = d
        self.init(dimension: d, n: n)
    }
    
    public init(dimension d: Int, n: Int) {
        let d = d <= 1 ? 19 : d
        self.grid = Array(repeating: Array(repeating: nil, count: d), count: d)
        self.n = n
    }
    
    public init(grid: [[Player?]], n: Int, turn: Player, lastPiece: Point? = nil) {
        self.grid = grid
        self.n = n
        self.turn = turn
        self.lastPiece = lastPiece
    }

    
    public var dimension: Int {
        return grid.count
    }
    
    public var numberOfPieces: Int {
        var count = 0
        for row in grid {
            for pos in row {
                if pos != nil {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    public static func ==(lhs: ConnectNBoard, rhs: ConnectNBoard) -> Bool {
        if lhs.dimension != rhs.dimension {
            return false
        }
        
        if lhs.lastPiece != rhs.lastPiece {
            return false
        }
        
        if lhs.turn != rhs.turn {
            return false
        }
        
        let dimension = lhs.dimension
        
        for i in 0..<dimension {
            for j in 0..<dimension {
                if lhs.grid[i][j] != rhs.grid[i][j] {
                    return false
                }
            }
        }
        
        if lhs.n != rhs.n {
            return false
        }
        
        return true
    }
}
