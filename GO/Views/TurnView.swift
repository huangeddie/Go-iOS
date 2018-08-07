//
//  TurnView.swift
//  GO
//
//  Created by Eddie Huang on 8/7/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
class TurnView: UIView {
    
    @IBInspectable
    var gameEnded: Bool = false
    
    var turn = Player.black

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        backgroundColor = UIColor.clear

        let outline = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
        outline.addClip()
        outline.lineWidth = 10
        
        if turn == .black {
            UIColor.black.set()
        } else {
            UIColor.white.set()
        }
        
        outline.fill()
        
        if gameEnded {
            #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).setStroke()
            
            outline.stroke()
        }
    }
}
