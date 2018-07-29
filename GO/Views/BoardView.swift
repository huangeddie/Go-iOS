//
//  BoardView.swift
//  GO
//
//  Created by Eddie Huang on 7/29/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
public class BoardView: UIView {
    @IBInspectable var boardColor: UIColor = UIColor.brown
    @IBInspectable var dimension: Int = 19
    @IBInspectable var dots: Bool = false
    
    private var numberOfSquares: Int {
        return dimension - 1
    }
    
    var gridSize: CGSize {
        return CGSize(width: bounds.width * 0.9, height: bounds.height * 0.9)
    }
    
    var unitLength: CGFloat {
        return gridSize.height / CGFloat(dimension - 1)
    }
    
    var delegate: BoardDelegate?
    
    public override func draw(_ rect: CGRect) {
        boardColor.setFill()
        let background = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
        background.fill()
        
        let grid = UIBezierPath()
        for i in 0...numberOfSquares {
            grid.move(to: CGPoint(x: (bounds.width - gridSize.width) / 2, y: (bounds.height - gridSize.height) / 2 + CGFloat(i) * gridSize.height / CGFloat(numberOfSquares)))
            grid.addLine(to: CGPoint(x: (bounds.width - gridSize.width) / 2 + gridSize.width, y: (bounds.height - gridSize.height) / 2 + CGFloat(i) * gridSize.height / CGFloat(numberOfSquares)))

            grid.move(to: CGPoint(x: (bounds.width - gridSize.width) / 2 + CGFloat(i) * gridSize.width / CGFloat(numberOfSquares), y: (bounds.height - gridSize.height) / 2))
            grid.addLine(to: CGPoint(x: (bounds.width - gridSize.width) / 2 + CGFloat(i) * gridSize.width / CGFloat(numberOfSquares), y: (bounds.height - gridSize.height) / 2 + gridSize.height))
        }
        UIColor.black.setStroke()


        // create the dots
        if (dots) {
            UIColor.black.setFill()
            var w = gridSize.width / 3
            var h = gridSize.height / 3
            let s = CGSize(width: gridSize.width / 100, height: gridSize.width / 100)
            switch numberOfSquares {
            case 12:
                w = gridSize.width / 4
                h = gridSize.height / 4
            case 8:
                w = gridSize.width / 4
                h = gridSize.height / 4
            default:
                break
            }

            let arr = [
                CGRect(origin: CGPoint(x: (bounds.width - s.width) / 2, y: (bounds.height - s.height) / 2), size: s),
                CGRect(origin: CGPoint(x: (bounds.width - s.width) / 2 - w, y: (bounds.height - s.height) / 2 + h), size: s),
                CGRect(origin: CGPoint(x: (bounds.width - s.width) / 2 + w, y: (bounds.height - s.height) / 2 + h), size: s),
                CGRect(origin: CGPoint(x: (bounds.width - s.width) / 2 - w, y: (bounds.height - s.height) / 2 - h), size: s),
                CGRect(origin: CGPoint(x: (bounds.width - s.width) / 2 + w, y: (bounds.height - s.height) / 2 - h), size: s)
            ]

            for i in arr {
                UIBezierPath(ovalIn: i).fill()
            }
        }

        grid.fill()

        grid.stroke()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let location = touch.location(in: self)
            
            print(location)
            
            let margin = (bounds.height - gridSize.height) / 2
            
            let gridX = max(location.x - margin, 0)
            let gridY = max(location.y - margin, 0)
            
            let x = Int(gridX / unitLength)
            let y = Int(gridY / unitLength)
            
            let point = Point(x, y)
            
            delegate?.attemptedToMakeMove(point)
            
        }
    }
}
