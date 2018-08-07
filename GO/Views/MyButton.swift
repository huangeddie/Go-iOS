//
//  MyButton.swift
//  GO
//
//  Created by Eddie Huang on 8/7/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable
class MyButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    @IBInspectable
    var color: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let outline = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5)
        outline.addClip()
        color.setFill()
        outline.fill()
    }

}
