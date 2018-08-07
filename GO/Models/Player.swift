//
//  Player.swift
//  GO
//
//  Created by Eddie Huang on 3/21/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

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
    var color: UIColor {
        switch self {
        case .white:
            return #colorLiteral(red: 0.9754120272, green: 0.9754120272, blue: 0.9754120272, alpha: 1)
        case .black:
            return #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        }
    }
}
