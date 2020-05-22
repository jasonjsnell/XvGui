//
//  Widgets.swift
//  XvGui
//
//  Created by Jason Snell on 12/3/18.
//  Copyright © 2018 Jason Snell. All rights reserved.
//

import UIKit
import XvUtils
import QuartzCore

public class MeterBar{
    
    //const
    public static let BAR_ANCHOR_TOP:String = "barAnchorTop"
    public static let BAR_ANCHOR_BOTTOM:String = "barAnchorBottom"
    public static let BAR_ANCHOR_LEFT:String = "barAnchorLeft"
    public static let BAR_ANCHOR_RIGHT:String = "barAnchorRight"
    
    public static let BAR_VERTICAL:String = "barVertical"
    public static let BAR_HORIZONTAL:String = "barHorizontal"
    
    //MARK: RECT
    public class func createBar(withInnerRect:UIView, insideOfOuterRect:UIView) -> UIView {
        
        //make bar same size and location as larger, outer rect
        let bar:UIView = UIView()
        bar.frame = insideOfOuterRect.frame
        
        //move larger
        insideOfOuterRect.frame.origin.x = 0
        insideOfOuterRect.frame.origin.y = 0
        
        //have inner match size and loc of outer, minus the border
        withInnerRect.frame.origin.x = insideOfOuterRect.frame.origin.x + insideOfOuterRect.layer.borderWidth
        withInnerRect.frame.origin.y = insideOfOuterRect.frame.origin.y + insideOfOuterRect.layer.borderWidth
        withInnerRect.frame.size.width = insideOfOuterRect.frame.size.width - (insideOfOuterRect.layer.borderWidth * 2)
        withInnerRect.frame.size.height = insideOfOuterRect.frame.size.height - (insideOfOuterRect.layer.borderWidth * 2)
      
        //add outer (background), then innner (foreground)
        bar.addSubview(insideOfOuterRect)
        bar.addSubview(withInnerRect)
        
        return bar
    }
    
    public class func set(bar:UIView, toPercent:Double, withAnchor:String){
        
        let outer:UIView = bar.subviews[0]
        let inner:UIView = bar.subviews[1]
        
        let maxHeight:CGFloat = outer.frame.size.height - (outer.layer.borderWidth * 2)
        let innerHeight:CGFloat = Number.get(percentage: CGFloat(toPercent), ofValue: maxHeight)
       
        if (withAnchor == BAR_ANCHOR_BOTTOM){
            Shapes.set(height: innerHeight, ofView: inner)
            Shapes.set(y:maxHeight-innerHeight+1, ofView:inner)
        }
    }
    
    public class func set(floatingBar:UIView, toTopPercent:Double, toBottomPercent:Double, withOrientation:String){
        
        let outer:UIView = floatingBar.subviews[0]
        let inner:UIView = floatingBar.subviews[1]
        
        if (withOrientation == BAR_VERTICAL){
            
            let maxHeight:CGFloat = outer.frame.size.height - (outer.layer.borderWidth * 2)
            
            //calc difference in percentages...
            let differencePct:Double = toTopPercent - toBottomPercent
            
            if (differencePct > 1.0){
                
                //than convert to a cgfloat to get height of bar
                let innerHeight:CGFloat = Number.get(percentage: CGFloat(differencePct), ofValue: maxHeight)
                Shapes.set(height: innerHeight, ofView: inner)
                
                //get top pct of total height, substract total height, and that gives you distance from the top
                let topY:CGFloat = maxHeight - Number.get(percentage: CGFloat(toTopPercent), ofValue: maxHeight)
                Shapes.set(y:topY+1, ofView:inner)
                
            } else {
               
                //set size to 1
                Shapes.set(height: 1.0, ofView: inner)
                
                //flip the negative
                let invertedPct:Double = differencePct * -1
                //add half of it to the top (so loc is halfway between the two
                let newTopPct:Double = toTopPercent + (invertedPct / 2)
                //calc top y nomrally
                let topY:CGFloat = maxHeight - Number.get(percentage: CGFloat(newTopPct), ofValue: maxHeight)
                Shapes.set(y:topY+1, ofView:inner)
                
            }
        
        }
      
    }
    
    public class func set(bar:UIView, backgroundColor:UIColor){
        bar.subviews[1].backgroundColor = backgroundColor
    }
    
}
