//
//  GOBoard.swift
//  GO
//
//  Created by Edward Huang on 5/23/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

public struct GOBoard: Board {
    
    // MARK: Board Properties
    /**
     Bottom left point is (0,0). Top right point is (gridLength - 1, gridLength - 1)
     nil: empty space
     true: white piece
     false: black piece
     */
    ///Stores the state of the board
    public var grid: [[Player?]]
    ///The last piece that was placed
    public var lastPiece: Point? = nil
    ///Indicates whose turn it is
    public var turn = Player.black
    
    // MARK: GO Properties
    ///Indicates where the player can't move due to ko protection
    public private(set) var koProtection: Point? = nil
    ///Indicates whether or not the previous move was passed
    public private(set) var previousMoveWasPassed = false
    
    ///Indicates whether the game has ended
    public private(set) var gameEnded = false
    
    // MARK: Derived Properties
    public var empties: [Point] {
        
        var ret = [Point]()
        
        for i in 0...dimension-1 {
            for j in 0...dimension-1 {
                if grid[i][j] == nil {
                    let coor = Point(i,j)
                    
                    ret.append(coor)
                }
            }
        }
        
        return ret
    }
    
    /// The dimension of the gameboard
    public var dimension: Int {
        return grid.count
    }
    
    public var numberOfPieces: Int {
        var count = 0
        for row in grid {
            for i in row where i != nil {
                count += 1
            }
        }
        
        return count
    }
    
    
    
    // MARK: Initializers
    
    public init() {
        self.init(dimension: 19)
    }
    public init(dimension n: Int) {
        let _n = n <= 1 ? 19 : n
        grid = Array(repeating: Array(repeating: nil, count: _n), count: _n)
    }
    
    public init(grid: [[Player?]], koProtection: Point?, previousMoveWasPassed: Bool, lastPiece: Point?, turn: Player, gameEnded: Bool) {
        self.grid = grid
        self.koProtection = koProtection
        self.previousMoveWasPassed = previousMoveWasPassed
        self.lastPiece = lastPiece
        self.turn = turn
        self.gameEnded = gameEnded
    }
    
    public init(_ other: GOBoard) {
        self.grid = other.grid
        self.koProtection = other.koProtection
        self.previousMoveWasPassed = other.previousMoveWasPassed
        self.lastPiece = other.lastPiece
        self.turn = other.turn
        self.gameEnded = other.gameEnded
    }
}

extension GOBoard: Equatable {
    public static func ==(lhs: GOBoard, rhs: GOBoard) -> Bool {
        if lhs.dimension != rhs.dimension {
            return false
        }
        
        if lhs.koProtection != rhs.koProtection {
            return false
        }
        
        if lhs.previousMoveWasPassed != rhs.previousMoveWasPassed {
            return false
        }
        
        if lhs.lastPiece != rhs.lastPiece {
            return false
        }
        
        if lhs.turn != rhs.turn {
            return false
        }
        
        if lhs.gameEnded != rhs.gameEnded {
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
        return true
    }
}

extension GOBoard: CustomStringConvertible {
    public var description: String {
        let ret = NSMutableString()
        
        ret.append("\n")
        
        for row in grid {
            for index in row {
                if let owner = index {
                    if owner == .white {
                        ret.append("w ")
                    } else {
                        ret.append("b ")
                    }
                } else {
                    ret.append("_ ")
                }
            }
            ret.append("\n")
        }
        
        return ret as String
    }
}

