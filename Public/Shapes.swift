//
//  Shapes.swift
//  XvGui
//
//  Created by Jason Snell on 12/3/18.
//  Copyright © 2018 Jason Snell. All rights reserved.
//

import UIKit
import QuartzCore

public class Shapes{
    
    //MARK: RECT
    public class func createRect(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat) -> UIView {
        
        return UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    }
    
    //used to get a default rect, often used for an inner rect of a bar that will later be automatically resizzed
    public class func createRect(bgColor:UIColor) -> UIView {
        
        let rect:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        rect.backgroundColor = bgColor
        return rect
    }

    public static func createRect(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat,
        bgColor:UIColor) -> UIView{
        
        let rect:UIView = createRect(x: x, y: y, width: width, height: height)
        rect.backgroundColor = bgColor
        
        return rect
    }
    
    public static func createRect(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat,
        bgColor:UIColor,
        borderColor:UIColor,
        borderWidth:CGFloat) -> UIView{
        
        let rect:UIView = createRect(x: x, y: y, width: width, height: height, bgColor:bgColor)
        rect.layer.borderColor = borderColor.cgColor
        rect.layer.borderWidth = borderWidth
        
        return rect
    }
    
    //MARK: CIRCLE
    
    public static func createCircle(
        x:CGFloat,
        y:CGFloat,
        diameter:CGFloat) -> UIView {
        
        let circle:UIView = UIView(frame: CGRect(x: x, y: y, width: diameter, height: diameter))
        circle.layer.cornerRadius = diameter / 2
        return circle
    }
    
    public static func createCircle(
        x:CGFloat,
        y:CGFloat,
        diameter:CGFloat,
        bgColor:UIColor) -> UIView {
        
        let circle:UIView = createCircle(x: x, y: y, diameter: diameter)
        circle.backgroundColor = bgColor
        return circle
        
    }
    
    public static func createCircle(
        x:CGFloat,
        y:CGFloat,
        diameter:CGFloat,
        bgColor:UIColor,
        borderColor:UIColor,
        borderWidth:CGFloat) -> UIView {
        
        let circle:UIView = createCircle(x: x, y: y, diameter: diameter, bgColor: bgColor)
        circle.layer.borderColor = borderColor.cgColor
        circle.layer.borderWidth = borderWidth
        
        return circle
    }
    
    
    //MARK: attributes
    public static func set(width:CGFloat, height:CGFloat, ofView:UIView){
        set(width: width, ofView: ofView)
        set(height: height, ofView: ofView)
    }
    
    public static func set(x:CGFloat, y:CGFloat, ofView:UIView){
        set(x:x, ofView: ofView)
        set(y:y, ofView: ofView)
    }
    
    public static func set(width:CGFloat, ofView:UIView){
        ofView.frame.size.width = width
    }
    
    public static func set(height:CGFloat, ofView:UIView){
        ofView.frame.size.height = height
    }

    public static func set(x:CGFloat, ofView:UIView){
        ofView.frame.origin.x = x
    }
    
    public static func set(y:CGFloat, ofView:UIView){
        ofView.frame.origin.y = y
    }
}
