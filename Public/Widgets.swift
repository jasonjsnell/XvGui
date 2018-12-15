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

public class Widgets{
    
    //const
    public static let BAR_ANCHOR_TOP:String = "barAnchorTop"
    public static let BAR_ANCHOR_BOTTOM:String = "barAnchorBottom"
    public static let BAR_ANCHOR_LEFT:String = "barAnchorLeft"
    public static let BAR_ANCHOR_RIGHT:String = "barAnchorRight"
    
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
    
    public class func set(bar:UIView, backgroundColor:UIColor){
        bar.subviews[1].backgroundColor = backgroundColor
    }
    
}
