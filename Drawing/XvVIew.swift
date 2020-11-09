//
//  XvVIew.swift
//  XvGui
//
//  Created by Jason Snell on 9/21/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//interaction delegates
public protocol XvViewTapDelegate:class {
    func tapEnded(view:XvView)
}
public protocol XvViewDragDelegate:class {
    func dragBegan(view:XvView)
    func dragging(view:XvView)
    func dragEnded(view:XvView)
}
public protocol XvViewHoverDelegate:class {
    func hoverBegan(view:XvView)
    func hoverEnded(view:XvView)
}

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
    
    //MARK: Rotation
    public func rotate(degrees:CGFloat){
        
        let transform:CGAffineTransform = CGAffineTransform(
            rotationAngle: CGFloat(
                CGFloat.pi*degrees/180.0
            )
        )
        _view.transform = transform
    }
    

    //MARK: Debug
    public func showBoundingBox(){
        
        _view.layer.borderColor = UIColor.red.cgColor
        _view.layer.borderWidth = 2.0
    }
    
    
    //MARK: - Interactions -
    
    //MARK: Tap
    fileprivate var tap:UITapGestureRecognizer?
    fileprivate var tapDelegate:XvViewTapDelegate?
    
    public func addTap(delegate:XvViewTapDelegate){
        
        //if existing, clear it
        if (tap != nil) {
            view.removeGestureRecognizer(tap!)
            tap = nil
            tapDelegate = nil
        }
        
        //re-create it
        tapDelegate = delegate
        tap = UITapGestureRecognizer(
            target: self,
            action: #selector(viewTapped)
        )
        
        view.addGestureRecognizer(tap!)
        view.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped(){
        tapDelegate?.tapEnded(view: self)
    }
    
    
    //MARK: Drag
    
    fileprivate var drag:UILongPressGestureRecognizer?
    fileprivate var dragDelegate:XvViewDragDelegate?
    
    public func addDrag(delegate:XvViewDragDelegate){
        
        //if existing, clear it
        if (drag != nil) {
            view.removeGestureRecognizer(drag!)
            drag = nil
            dragDelegate = nil
        }
        
        //re-create it
        dragDelegate = delegate
        drag = UILongPressGestureRecognizer(
            target: self,
            action: #selector(viewDragged)
        )
        drag!.minimumPressDuration = 0.1
        
        view.addGestureRecognizer(drag!)
        view.isUserInteractionEnabled = true
    }
    
    @objc func viewDragged(){
        
        if (drag != nil) {
         
            if (drag!.state == .began) {
                
                dragDelegate?.dragBegan(view: self)
                
            } else if (drag!.state == .changed) {
                
                dragDelegate?.dragging(view: self)
            
            } else if (drag!.state == .ended) {
                
                dragDelegate?.dragEnded(view: self)
            }
        }
    }
    
   
    
    //MARK: Hover
    
    fileprivate var hover:UIHoverGestureRecognizer?
    fileprivate var hoverDelegate:XvViewHoverDelegate?
    
    public func addHover(delegate:XvViewHoverDelegate){
        
        //if existing, clear it
        if (hover != nil) {
            view.removeGestureRecognizer(hover!)
            hover = nil
            hoverDelegate = nil
        }
        
        //re-create it
        hoverDelegate = delegate
        hover = UIHoverGestureRecognizer(
            target: self,
            action: #selector(viewHovered)
        )
        
        view.addGestureRecognizer(hover!)
        view.isUserInteractionEnabled = true
    }
    
    @objc func viewHovered(){
        
        if (hover != nil) {
         
            if (hover!.state == .began) {
                
                hoverDelegate?.hoverBegan(view: self)
            
            } else if (hover!.state == .ended) {
                
                hoverDelegate?.hoverEnded(view: self)
            }
        }
    }
    

}
