//
//  TimeCounterView.swift
//  CWBTimeOut
//
//  Created by Johnny on 7/14/15.
//  Copyright (c) 2015 ExxonMobil. All rights reserved.
//

import UIKit

let Minutes = 60
let π:CGFloat = CGFloat(M_PI)

@IBDesignable class TimeCounterView: UIView {

    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    @IBInspectable var counter: Int = 0 {
        didSet {
            if counter <= Minutes {
                setNeedsDisplay()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        // Drawing Arc
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let arcWidth: CGFloat = 76
        let startAngle: CGFloat = 3 * π / 4
        let endAngle: CGFloat = π / 4
        
        var path = UIBezierPath(arcCenter: center, radius: radius / 2 - arcWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()

        // Draw the outline
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        let arcLenghtPerGlass = angleDifference / CGFloat(Minutes)
        
        let outlineEndAngle = arcLenghtPerGlass * CGFloat(counter) + startAngle
        var outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width / 2 - 2.5, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)
        
        outlinePath.addArcWithCenter(center, radius: bounds.width / 2 - arcWidth + 2.5, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
      
        outlinePath.closePath()
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        
        UIColor.grayColor().setFill()
        outlinePath.fill()
        
        outlinePath.stroke()
    }

}
