//
//  Board.swift
//  GO
//
//  Created by Eddie Huang on 3/25/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

public protocol Board: Codable, Equatable {
    ///Stores the state of the board
    var grid: [[Player?]] {
        get
    }
    
    var turn: Player {
        get
    }
    
    var lastPiece: Point? {
        get
    }
    
    var empties: [Point] {
        get
    }
    
    var dimension: Int {
        get
    }
    
    var numberOfPieces: Int {
        get
    }
    
    init()
    
    init(dimension: Int)
}
