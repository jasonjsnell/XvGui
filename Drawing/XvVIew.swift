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
    
    public var alpha:CGFloat {
        get { return _view.alpha }
        set {
            var newAlpha:CGFloat = newValue
            if (newAlpha > 1.0) { newAlpha = 1.0 } else if (newAlpha < 0.0) { newAlpha = 0.0 }
            _view.alpha = newAlpha
        }
    }

    
}
