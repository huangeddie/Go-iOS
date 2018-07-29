//
//  Game.swift
//  GO
//
//  Created by Eddie Huang on 3/21/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

public class Game<T: Board> {
    public init(dimension: Int) {
        _ = startGame(dimension: dimension)
    }
    
    public init(board: T) {
        _ = startGame(board: board)
    }
    
    public var history: [T] = [T()]
    
    public var board: T {
        return history.last!
    }
    
    public func startGame(dimension: Int) -> T {
        history = [T(dimension: dimension)]
        return board
    }
    
    public func startGame(board: T) {
        history = [board]
    }
    
    public func loadGame(mode: Mode, dimension: Int) -> T? {
        let fileName = "\(mode)\(dimension)"
        if Storage.fileExists(fileName, in: .documents) {
            let ret = Storage.retrieve(fileName, from: .documents, as: [T].self)
            history =  ret
            return board
        }
        
        return nil
    }
    
    public func saveGame(mode: Mode, dimension: Int) {
        let fileName = "\(mode)\(dimension)"
        Storage.store(history, to: .documents, as: fileName)
    }
    
    public func makeMove(x: Int, y: Int) throws {
        do {
            let point = Point(x, y)
            let newBoard = try Action.makeMove(board, point: point)
            history.append(newBoard)
        }
    }
    
    public func makeMove(_ point: Point) throws {
        try makeMove(x: point.x, y: point.y)
    }
    
    public func pass() {
        if let board = board as? GOBoard {
            let newBoard = Action.playerPasses(board)
            history.append(newBoard as! T)
        }
    }
    
    public func end() {
        if let board = board as? GOBoard {
            let newBoard = Action.endGame(board)
            history.append(newBoard as! T)
        }
    }
    
    var gameEnded: Bool {
        let ret = Evaluate.gameEnded(board)
        return ret
    }
    
    public func undo() {
        if history.count > 1 {
            _ = history.popLast()
        }
    }
    
    public func reset() {
        let dimension = board.dimension
        history = [T(dimension: dimension)]
    }
}
