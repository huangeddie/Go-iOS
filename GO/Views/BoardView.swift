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
    
    var board: GOBoard?
    
    var considering: Point?
    
    private var numberOfSquares: Int {
        return dimension - 1
    }
    
    var gridSize: CGSize {
        return CGSize(width: bounds.width * 0.9, height: bounds.height * 0.9)
    }
    
    var gridPosition: CGPoint {
        return CGPoint(x: bounds.width * 0.05, y: bounds.height * 0.05)
    }
    
    var unitLength: CGFloat {
        return gridSize.height / CGFloat(dimension - 1)
    }
    
    var margin: CGFloat {
        return (bounds.width - gridSize.width) / 2
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
        UIColor.darkGray.setStroke()

        grid.fill()

        grid.stroke()
        
        // create the dots
        if dots && (dimension == 19 || dimension == 7) {
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
        
        // Show where user is touching
        if let considering = considering {
            UIColor.red.setStroke()
            let outline = UIBezierPath()
            outline.move(to: CGPoint(x: gridPosition.x + unitLength * CGFloat(considering.x), y: gridPosition.y))
            outline.addLine(to: CGPoint(x: gridPosition.x + unitLength * CGFloat(considering.x), y: bounds.maxY - margin))
            
            outline.move(to: CGPoint(x: gridPosition.x, y: gridPosition.y + unitLength * CGFloat(considering.y)))
            outline.addLine(to: CGPoint(x: bounds.maxX - margin, y: gridPosition.y + unitLength * CGFloat(considering.y)))
            
            outline.stroke()
        }
        
        // Add the pieces
        if let goBoard = board {
            let pieceRadius = unitLength / 2 * 0.65
            let pieceDiameter = pieceRadius * 2
            
            for x in 0..<dimension {
                for y in 0..<dimension {
                    if let player = goBoard.grid[x][y] {
                        let position = CGPoint(x: gridPosition.x + unitLength * CGFloat(x) - pieceRadius, y: gridPosition.y + unitLength * CGFloat(y) - pieceRadius)
                        
                        let rect = CGRect(origin: position, size: CGSize(width: pieceDiameter, height: pieceDiameter))
                        
                        player.color.setFill()
                        
                        UIBezierPath(ovalIn: rect).fill()
                    }
                }
            }
        }
    }
    
    func getPoint(_ location: CGPoint) -> Point {
        let margin = (bounds.height - gridSize.height) / 2
        
        let gridX = max(location.x - margin, 0)
        let gridY = max(location.y - margin, 0)
        
        let x = Int((gridX / unitLength).rounded())
        let y = Int((gridY / unitLength).rounded())
        
        let point = Point(x, y)
        return point
    }
    
    public func update(_ board: GOBoard) {
        self.dimension = board.dimension
        self.board = board
        self.setNeedsDisplay()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)

            let point = getPoint(location)
            
            considering = nil
            
            delegate?.attemptedToMakeMove(point)
            
        }
    }
    
    fileprivate func showConsideration(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let point = getPoint(location)
            
            considering = point
            
            setNeedsDisplay()
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        showConsideration(touches)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showConsideration(touches)
    }
}
