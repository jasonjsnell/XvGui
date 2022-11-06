//
//  Shapes.swift
//  XvGui
//
//  Created by Jason Snell on 12/3/18.
//  Copyright © 2018 Jason Snell. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif
import QuartzCore


public class Shapes{
    
    //MARK: - RECT
    public class func createRect(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat) -> UIView {
        
        return UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    }
    
    //used to get a default rect, often used for an inner rect of a bar that will later be automatically resized
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
    
    //MARK: RECT: GRADIENT
    
    //pass in an array of colors which will create the background gradient
    //UIColor version
    public class func createRect(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat,
        bgGradient:[UIColor],
        rotate:Bool) -> UIView {
        
        let rect:UIView = createRect(x: x, y: y, width: width, height: height)
        
        let gradient:CAGradientLayer = CAGradientLayer()
        let cgColors:[CGColor] = bgGradient.map { $0.cgColor}
        gradient.colors = cgColors
        
        if (rotate) { gradient.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi / 2)) }
        
        gradient.frame = rect.bounds
        
        rect.layer.insertSublayer(gradient, at: 0)
        return rect
    }
    
    //CGColor version
    public class func createRect(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat,
        bgGradient:[CGColor],
        rotate:Bool) -> UIView {
        
        let rect:UIView = createRect(x: x, y: y, width: width, height: height)
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = bgGradient
        
        if (rotate) { gradient.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi / 2)) }
        gradient.frame = rect.bounds
        rect.layer.insertSublayer(gradient, at: 0)
        return rect
    }
    
    
    //MARK: - CIRCLE
    
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
        bgGradient:[UIColor]) -> UIView {
        
        let circle:UIView = createCircle(x: x, y: y, diameter: diameter)
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.type = .radial
        let cgColors:[CGColor] = bgGradient.map { $0.cgColor }
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        circle.layer.insertSublayer(gradient, at: 0)
        
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
    
    
    //MARK: - SET
    public static func set(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, ofView:UIView){
        set(x:x, ofView: ofView)
        set(y:y, ofView: ofView)
        set(width: width, ofView: ofView)
        set(height: height, ofView: ofView)
    }
    
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
    
    public static func set(diameter:CGFloat, ofCircle:UIView) {
        set(width: diameter, height: diameter, ofView: ofCircle)
        ofCircle.layer.cornerRadius = diameter / 2
    }
    
    //MARK: - REFRESH
    //have CA layer and it's sublayers resize to match the bounds of the main UIView
    public static func updateSublayersSize(ofView:UIView){
        
        ofView.layer.frame.size.width = ofView.frame.size.width
        ofView.layer.frame.size.height = ofView.frame.size.height
        
        if let sublayers:[CALayer] = ofView.layer.sublayers {
            
            for sublayer in sublayers {
                sublayer.frame.size.width = ofView.frame.size.width
                sublayer.frame.size.height = ofView.frame.size.height
            }
        }
    }
    
    //MARK: - GET
    
    public static func getWidth(ofView:UIView) -> CGFloat {
        return ofView.frame.size.width
    }
    
    public static func getHeight(ofView:UIView) -> CGFloat {
        return ofView.frame.size.height
    }

    public static func getX(ofView:UIView) -> CGFloat {
        return ofView.frame.origin.x
    }
    
    public static func getY(ofView:UIView) -> CGFloat {
        return ofView.frame.origin.y
    }
}
