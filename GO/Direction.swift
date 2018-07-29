//
//  Direction.swift
//  GO
//
//  Created by Eddie Huang on 3/25/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

public enum Direction: Int {
    case north, northEast, east, southEast, south, southWest, west, northWest
    public var opposite: Direction {
        let rawValue = (self.rawValue + 4) % 8
        return Direction.init(rawValue: rawValue)!
    }
}
