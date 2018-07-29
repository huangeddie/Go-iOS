//
//  Point.swift
//  GO
//
//  Created by Edward Huang on 6/3/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation


public struct Point: Codable {
    
    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func point(inDirection direction: Direction, atDistance distance: Int = 1) -> Point {
        if distance == 0 {
            return self
        }
        
        var newX = x
        var newY = y
        switch direction {
        case .north, .northEast, .northWest:
            newY += 1
        case .south, .southEast, .southWest:
            newY -= 1
        default:
            break
        }
        
        switch direction {
        case .west, .northWest, .southWest:
            newX -= 1
        case .east, .northEast, .southEast:
            newX += 1
        default:
            break
        }
        
        let neighbor = Point(newX, newY)
        return neighbor.point(inDirection: direction, atDistance: distance - 1)
    }
    
    var x: Int
    var y: Int
}

extension Point: Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    public static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
