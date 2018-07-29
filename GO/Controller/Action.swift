//
//  Action.swift
//  GO
//
//  Created by Eddie Huang on 3/21/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

enum MoveError: Error {
    case occupiedPosition
    case gameAlreadyEnded
    case outOfGridBounds
    case koProtection
    case positionSurroundedByOpponent
}

public class Action {
    
    public static func makeMove<T>(_ board: T, x: Int, y: Int) throws -> T where T : Board {
        let p = Point(x, y)
        return try makeMove(board, point: p)
    }
    
    public static func makeMove<T>(_ board: T, point: Point) throws -> T where T : Board {
        if let goBoard = board as? GOBoard {
            return try makeGOMove(goBoard, point: point) as! T
        }
        
        fatalError("Unknown board")
    }
    
    // MARK: Connect N
    static func makeConnectMove(_ board: ConnectNBoard, x: Int, y: Int) throws -> ConnectNBoard {
        let c = Point(x, y)

        do {
            let result = try makeConnectMove(board, point: c)
            return result
        } catch {
            throw error
        }
    }

    static func makeConnectMove(_ board: ConnectNBoard, point: Point) throws -> ConnectNBoard {
        let dimension = board.dimension
        var grid = board.grid
        var turn = board.turn
        var lastPiece = board.lastPiece
        let n = board.n

        if Analyze.containsFilledBlock(ofSize: n, forPlayer: turn, onGrid: grid) {
            throw MoveError.gameAlreadyEnded
        }

        if point.x >= dimension || point.y >= dimension || point.x < 0 || point.y < 0 {
            throw MoveError.outOfGridBounds
        }

        if grid[point.x][point.y] != nil {
            throw MoveError.occupiedPosition
        }

        grid[point.x][point.y] = turn
        lastPiece = point

        turn = turn.opponent

        return ConnectNBoard(grid: grid, n: n, turn: turn, lastPiece: lastPiece)
    }
    
    // MARK: GO
    static func makeGOMove(_ board: GOBoard, x: Int, y: Int) throws -> GOBoard {
        let c = Point(x, y)
        
        do {
            let result = try makeGOMove(board, point: c)
            return result
        } catch {
            throw error
        }
    }
    
    ///Returns true if the move was executed, false otherwise
    static func makeGOMove(_ board: GOBoard, point: Point) throws -> GOBoard {
        let gameEnded = board.gameEnded
        let dimension = board.dimension
        var grid = board.grid
        var koProtection = board.koProtection
        var turn = board.turn
        var lastPiece = board.lastPiece
        var previousMoveWasPassed = board.previousMoveWasPassed
        
        if gameEnded {
            throw MoveError.gameAlreadyEnded
        }
        if point.x >= dimension || point.y >= dimension || point.x < 0 || point.y < 0 {
            throw MoveError.outOfGridBounds
        }
        
        if grid[point.x][point.y] != nil {
            throw MoveError.occupiedPosition
        }
        
        // NEW ALGORITHM FOR MAKE MOVE
        
        // Place the piece
        grid[point.x][point.y] = turn
        
        // See if we capture any pieces. If the piece captured was protected by ko-protection, take back the piece and return false. Otherwise, remove the captured pieces.
        var capturedAny = false
        var groupsWithNoLiberties = Set<Set<Point>>()
        let adjacentOpposingGroups = Analyze.getAdjacentOpposingGroups(grid, point: point, player: turn)
        
        for group in adjacentOpposingGroups {
            if Analyze.numberOfLiberties(grid: grid, group: group) == 0 {
                groupsWithNoLiberties.insert(group)
            }
        }
        
        if let koProtection = koProtection {
            for group in groupsWithNoLiberties {
                if group.count == 1 && group.contains(koProtection) { // ko-protection
                    grid[point.x][point.y] = nil
                    throw MoveError.koProtection
                }
            }
        }
        
        if !groupsWithNoLiberties.isEmpty {
            capturedAny = true
            for group in groupsWithNoLiberties {
                // Remove opposing groups
                for piece in group {
                    grid[Int(piece.x)][Int(piece.y)] = nil
                }
            }
        }
        
        
        // If we didn't capture any pieces, see if the group that our new piece belongs to has no liberties.
        // If we have no liberties, take back the piece and return false
        // Otherwise configure the appropriate properties and return true
        if !capturedAny {
            let ownGroup = Analyze.explore(grid: grid, point: point, player: turn)
            if Analyze.numberOfLiberties(grid: grid, group: ownGroup) == 0 {
                grid[point.x][point.y] = nil
                throw MoveError.positionSurroundedByOpponent
            }
        }
        
        if groupsWithNoLiberties.count == 1 {
            let group = groupsWithNoLiberties.first!
            if group.count == 1 {
                koProtection = point
            } else {
                koProtection = nil
            }
        } else {
            koProtection = nil
        }
        
        lastPiece = point
        previousMoveWasPassed = false
        turn = turn.opponent
        
        let newBoard = GOBoard.init(grid: grid, koProtection: koProtection, previousMoveWasPassed: previousMoveWasPassed, lastPiece: lastPiece, turn: turn, gameEnded: gameEnded)
        
        return newBoard
    }
    
    
    static func endGame(_ board: GOBoard) -> GOBoard {
        let newBoard = GOBoard(grid: board.grid, koProtection: board.koProtection, previousMoveWasPassed: board.previousMoveWasPassed, lastPiece: board.lastPiece, turn: board.turn, gameEnded: true)
        return newBoard
    }
    
    ///If the previous move was also a pass, the game ends. Otherwise, it's the other player's turn
    static func playerPasses(_ board: GOBoard) -> GOBoard {
        if board.gameEnded {
            return GOBoard(board)
        }
        
        if board.previousMoveWasPassed {
            return Action.endGame(board)
        } else {
            let newBoard = GOBoard(grid: board.grid, koProtection: nil, previousMoveWasPassed: true, lastPiece: board.lastPiece, turn: board.turn.opponent, gameEnded: board.gameEnded)
            
            return newBoard
        }
    }
}
