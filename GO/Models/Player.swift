//
//  Player.swift
//  GO
//
//  Created by Eddie Huang on 3/21/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

public enum Player: String, Codable {
    case white, black
    var opponent: Player {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
}
