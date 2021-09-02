//
//  XvShape.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//MARK: - XV COMPOSITE SHAPE

open class XvCompositeShape:XvShape {
    
    public init(
        x:CGFloat = 0,
        y:CGFloat = 0,
        width:CGFloat = 0,
        height:CGFloat = 0
    ){
        
        //just the basics, no colors or backgrounds
        super.init(x: x, y: y, width: width, height: height, bgColor: .clear)
        
    }
    
    public func add(_ view:XvView) {
        _view.addSubview(view.view)
    }

    public func remove(_ view:XvView) {
        view.view.removeFromSuperview()
    }
 
    
    //MARK: Resize
    //call when changing size of XvRect and need gradients and sublayers to resize too
    open override func refreshSize(){
        
        //do not resize all sublayers, it forces the XvShapes inside to become the same dimensions as this parent
        //so don't call super.refreshSize()
        //just run updates on this object's frame
        
        _view.layer.frame.size.width = _view.frame.size.width
        _view.layer.frame.size.height = _view.frame.size.height
        
        
    }
    
}

//MARK: - XV SHAPE

open class XvShape:XvView {
    
    fileprivate var _bgColor:UIColor
    fileprivate var _borderColor:UIColor
    fileprivate var _borderWidth:CGFloat
    fileprivate var _cornerRadius:CGFloat
    internal let _gradient:CAGradientLayer = CAGradientLayer()
    
    public init(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat,
        bgColor:UIColor = .clear,
        borderColor:UIColor = .clear,
        borderWidth:CGFloat = 0.0,
        cornerRadius:CGFloat = 0.0,
        lineDashPattern:[NSNumber]? = nil) {
        
        //store vars
        _bgColor = bgColor
        _borderColor = borderColor
        _borderWidth = borderWidth
        _cornerRadius = cornerRadius
        
        //create view in super
        super.init(x: x, y: y, width: width, height: height)
        
        //set properties
        self.bgColor = bgColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        
        if (lineDashPattern != nil){
            _shapeLayer.lineDashPattern = lineDashPattern
        }
        
    }
    
    //MARK: Frame
    //shape changes to the frame also need to update the CAShapeLayer border
    public override var width:CGFloat {
        get { return super.width }
        set {
            super.width = newValue
            refreshBorder()
        }
    }
    
    public override var height:CGFloat {
        get { return super.height }
        set {
            super.height = newValue
            refreshBorder()
        }
    }
    
    //MARK: Background
    public var bgColor:UIColor {
        get { return _bgColor }
        set {
            _bgColor = newValue
            _view.backgroundColor = bgColor
        }
    }
    
    //MARK: Border
    public var borderColor:UIColor {
        get { return _borderColor }
        set {
            _borderColor = newValue
            //_view.layer.borderColor = _borderColor.cgColor
            _shapeLayer.strokeColor = _borderColor.cgColor
            refreshBorder()
        }
    }
    
    public var borderWidth:CGFloat {
        get { return _borderWidth }
        set {
            _borderWidth = newValue
            //_view.layer.borderWidth = _borderWidth
            _shapeLayer.lineWidth = _borderWidth
            
            refreshBorder()
        }
    }
    
    public var cornerRadius:CGFloat {
        get { return _cornerRadius }
        set {
            _cornerRadius = newValue
            //apply to both layer and shape layer so circles fills work properly
            _view.layer.cornerRadius = _cornerRadius
            _shapeLayer.cornerRadius = _cornerRadius
            
            refreshBorder()
        }
    }
    
    //MARK: Gradient
    public func create(gradient:[UIColor]) {
        
        //map uiColors to cgColors
        let cgColors:[CGColor] = gradient.map { $0.cgColor}
        
        //pass to cg func
        create(gradient: cgColors)
    }
    
    public func create(gradient:[CGColor]) {
        
        //save colors
        _gradient.colors = gradient
        
        //fit to rect
        _gradient.frame = _view.bounds
        
        //insert
        _view.layer.insertSublayer(_gradient, at: 0)
    }
    
    public var gradient:[CGColor]? {
        get { return _gradient.colors as? [CGColor] }
        set {
            if let gradColors:[CGColor] = newValue {
                _gradient.colors = gradColors
            }
            
        }
    }
    
    
    public func refreshBorder() {
        
        //border is drawn by the CAShapeLayer
        //so it needs updating for the border to match
        //shape changes in the view
        _shapeLayer.path = UIBezierPath(
            roundedRect: _view.bounds,
            cornerRadius: _cornerRadius
        ).cgPath
        
        //rounded rect is always used because it can be a rect or circle
    }
    
}

