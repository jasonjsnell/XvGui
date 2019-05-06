//
//  Textures.swift
//  XvGui
//
//  Created by Jason Snell on 2/13/19.
//  Copyright © 2019 Jason Snell. All rights reserved.
//

import UIKit
import QuartzCore

public class Textures{

    //MARK: - CLASS FUNCS -
    
    //convenience, full screen, black lines
    public class func createScanLines(
        lineHeight:CGFloat,
        spaceHeight:CGFloat) -> UIView {
        
        return createScanLines(x: 0.0, y: 0.0, width: Screen.width, height: Screen.height, color: .black, lineHeight: lineHeight, spaceHeight: spaceHeight)
    }
    
    public class func createScanLines(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat,
        color:UIColor,
        lineHeight:CGFloat,
        spaceHeight:CGFloat) -> UIView {
        
        //make frame
        let frame:CGRect = CGRect(x: x, y: y, width: width, height: height)
        
        //init view
        let scanLinesView:ScanLinesView = ScanLinesView(frame: frame)
        scanLinesView.backgroundColor = UIColor.clear
        
        //update vars
        scanLinesView.color = color
        scanLinesView.lineHeight = lineHeight
        scanLinesView.spaceHeight = spaceHeight
        
        //refresh display
        scanLinesView.setNeedsDisplay()
        
        //return view
        return scanLinesView
    }
}

//MARK: - VIEWS -
class ScanLinesView:UIView {
    
    //required
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    //set vars
    public var color:UIColor = .black
    public var lineHeight:CGFloat = 1.0
    public var spaceHeight:CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        
        //get context
        if let context:CGContext = UIGraphicsGetCurrentContext() {
            
            //color of each rect
            context.setFillColor(color.cgColor)
            
            //build var that will update for each line
            var buildY:CGFloat = 0.0
            
            //loop until whole frame is full
            while buildY <= frame.height {
                
                //make the rect
                let rect:CGRect = CGRect(
                    x: 0.0,
                    y: buildY,
                    width: frame.width,
                    height: lineHeight
                )
                
                // add rect using a fill (rather than stroke)
                context.addRect(rect)
                context.drawPath(using: .fill)
                
                //y loc of next line
                buildY += lineHeight + spaceHeight
                
            }
            
        } else { print("XvGui: Textures: ScanLinesView: Error getting CGContext") }
        
    }
}
