//
//  XvVIew.swift
//  XvGui
//
//  Created by Jason Snell on 9/21/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//class with x, y, width, height, etc...

open class XvView {
    
    internal var _view:UIView
    internal var _shapeLayer:CAShapeLayer

    public init(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat)
    {
        _view = UIView(
            frame: CGRect(
                x: x,
                y: y,
                width: width,
                height: height
            )
        )
        
        _shapeLayer = CAShapeLayer()
        
        //system colors (like .systemBackground) don't work on CAShapeLayers, so the background color will be set direcly on the UIView
        _shapeLayer.fillColor = UIColor.clear.cgColor
        _view.layer.addSublayer(_shapeLayer)
        
    }

    //MARK: Frame
    public var view:UIView {
        get { return _view }
    }

    public var x:CGFloat {
        get { return _view.frame.origin.x }
        set { _view.frame.origin.x = newValue }
    }

    public var y:CGFloat {
        get { return _view.frame.origin.y }
        set { _view.frame.origin.y = newValue }
    }
    
    public var xy:CGPoint {
        get { return _view.frame.origin }
        set { _view.frame.origin = newValue }
    }
    
    public var width:CGFloat {
        get { return _view.frame.size.width }
        set { _view.frame.size.width = newValue }
    }
    
    public var height:CGFloat {
        get { return _view.frame.size.height }
        set { _view.frame.size.height = newValue }
    }
    
    public var frame:CGRect {
        get { return _view.frame }
        set { _view.frame = newValue }
    }
    
    public var alpha:CGFloat {
        get { return _view.alpha }
        set {
            var newAlpha:CGFloat = newValue
            if (newAlpha > 1.0) { newAlpha = 1.0 } else if (newAlpha < 0.0) { newAlpha = 0.0 }
            _view.alpha = newAlpha
        }
    }
    
    public func rotate(degrees:CGFloat){
        
        let transform:CGAffineTransform = CGAffineTransform(
            rotationAngle: CGFloat(
                CGFloat.pi*degrees/180.0
            )
        )
        _view.transform = transform
    }
    

    public func showBoundingBox(){
        
        _view.layer.borderColor = UIColor.red.cgColor
        _view.layer.borderWidth = 2.0
    }
    
    
    //call when changing size of XvShape and need gradients and sublayers to resize too
    public func refreshSize(){
        print("is XvView refreshSize ever called?")
        _view.layer.frame.size.width = _view.frame.size.width
        _view.layer.frame.size.height = _view.frame.size.height
        
        if let sublayers:[CALayer] = _view.layer.sublayers {
            
            for sublayer in sublayers {
                sublayer.frame.size.width = _view.frame.size.width
                sublayer.frame.size.height = _view.frame.size.height
            }
        }        
    }
    
    
    
}
