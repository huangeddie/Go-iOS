//
//  MyButton.swift
//  GO
//
//  Created by Eddie Huang on 8/7/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@objc
enum ButtonType: Int {
    case new, undo, pass, none
}

@IBDesignable
class MyButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    @IBInspectable
    var color: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    @IBInspectable
    var type: Int = 0
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let outline = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5)
        outline.addClip()
        color.setFill()
        outline.fill()
        
        let pencil = UIBezierPath()
        pencil.lineWidth = 3
        pencil.lineCapStyle = .round
        pencil.lineJoinStyle = .round
        
        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setStroke()
        
        if let buttonType = ButtonType(rawValue: type) {
            
            let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            let radius: CGFloat = 10
            
            let gamma = radius * (CGFloat(3).squareRoot() / 2)
            let omega = radius / 2
            
            switch buttonType {
            case .new:
                pencil.move(to: CGPoint(x: center.x - radius, y: center.y))
                pencil.addLine(to: CGPoint(x: center.x + radius, y: center.y))
                
                pencil.move(to: CGPoint(x: center.x, y: center.y - radius))
                pencil.addLine(to: CGPoint(x: center.x, y: center.y + radius))
            case .undo:
                pencil.addArc(withCenter: center, radius: radius, startAngle: CGFloat.pi / 2,
                              endAngle: CGFloat.pi, clockwise: false)
                
                let tip = pencil.currentPoint
                pencil.addLine(to: center)
                pencil.move(to: tip)
                pencil.addLine(to: tip.applying(.init(translationX: 0, y: -radius)))
                
            case .pass:
                
                pencil.addArc(withCenter: center, radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
                
                let tip = pencil.currentPoint
                
                pencil.addLine(to: tip.applying(.init(translationX: omega, y: -gamma)))
                
                pencil.move(to: tip)
                
                pencil.addLine(to: tip.applying(.init(translationX: -gamma, y: -omega)))
                
            default:
                break
            }
            
            pencil.stroke()
        }
    }

}
