//
//  XvCircle.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//MARK: - XV CIRCLE
open class XvCircle:XvShape {
    
    fileprivate var _circleGradientMask:CAShapeLayer?
    
    public init(
        x:CGFloat,
        y:CGFloat,
        diameter:CGFloat,
        bgColor:UIColor = .white,
        borderColor:UIColor = .clear,
        borderWidth:CGFloat = 0.0,
        lineDashPattern:[NSNumber]? = nil) {
        
        super.init(
            x: x,
            y: y,
            width: diameter,
            height: diameter,
            bgColor: bgColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: diameter/2,
            lineDashPattern: lineDashPattern
        )
        
        _shapeLayer.path = UIBezierPath(ovalIn: _view.bounds).cgPath
        
    }
    
    public var diameter:CGFloat {
        get { return width }
        set {
            width = newValue
            height = newValue
            cornerRadius = newValue/2
            
            //if a gradient has been added, resize it
            if (_circleGradientMask != nil) {
                _gradient.frame = _view.bounds
                _circleGradientMask!.path = UIBezierPath(
                    roundedRect: view.bounds,
                    cornerRadius: cornerRadius
                ).cgPath
            }
        }
    }
    
    public override func create(gradient:[UIColor]) {
        
        let cgColors:[CGColor] = gradient.map { $0.cgColor }
        create(gradient: cgColors)
    }
    
    public override func create(gradient:[CGColor]) {
        
        //create and shape the gradient layer
        _gradient.type = .radial
        _gradient.colors = gradient
        _gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        _gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        _gradient.frame = _view.bounds
        
        //create and apply the mask layer
        _circleGradientMask = CAShapeLayer()
        _circleGradientMask!.path = UIBezierPath(
            roundedRect: view.bounds,
            cornerRadius: cornerRadius
        ).cgPath
        _gradient.mask = _circleGradientMask!
        
        //insert the masked gradient into the view
        _view.layer.insertSublayer(_gradient, at: 0)
    }
}
