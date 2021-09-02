//
//  XvRect.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//MARK: - XV RECT
public class XvRect:XvShape {
    
    override public init(
        x:CGFloat = 0,
        y:CGFloat = 0,
        width:CGFloat,
        height:CGFloat,
        bgColor:UIColor = .white,
        borderColor:UIColor = .black,
        borderWidth:CGFloat = 0.0,
        cornerRadius:CGFloat = 0.0,
        lineDashPattern:[NSNumber]? = nil) {
        
        super.init(
            x: x,
            y: y,
            width: width,
            height: height,
            bgColor: bgColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius,
            lineDashPattern: lineDashPattern
        )
    }
    
    //MARK: Gradient
    public func create(gradient:[UIColor], rotate:Bool = false) {
        
        //map uiColors to cgColors
        let cgColors:[CGColor] = gradient.map { $0.cgColor}
        create(gradient: cgColors, rotate: rotate)
    }
    
    public func create(gradient:[CGColor], rotate:Bool = false) {
        
        //rotatation
        if (rotate) {
            _gradient.setAffineTransform(
                CGAffineTransform(
                    rotationAngle: CGFloat.pi / 2
                )
            )
        }
        
        super.create(gradient: gradient)
    }
}
