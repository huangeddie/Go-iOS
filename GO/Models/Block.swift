//
//  Block.swift
//  GO
//
//  Created by Eddie Huang on 3/25/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation


struct Block: Hashable, Equatable {
    
    let point: Point
    let direction: Direction
    let length: Int
    init(point: Point, direction: Direction, length: Int) {
        self.point = point
        self.direction = direction
        self.length = length
    }
    
    var hashValue: Int {
        return point.hashValue ^ direction.hashValue ^ length
    }
    
    static func ==(lhs: Block, rhs: Block) -> Bool {
        return lhs.direction == rhs.direction && lhs.point == rhs.point && lhs.length == rhs.length
    }
}
