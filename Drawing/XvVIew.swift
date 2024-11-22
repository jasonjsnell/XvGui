//
//  XvVIew.swift
//  XvGui
//
//  Created by Jason Snell on 9/21/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

//interaction delegates
public protocol XvViewTapDelegate:AnyObject {
    func tapEnded(view:XvView)
}
public protocol XvViewDragDelegate:AnyObject {
    func dragBegan(view:XvView, location:XvViewLocation)
    func dragging(view:XvView, location:XvViewLocation)
    func dragEnded(view:XvView, location:XvViewLocation)
}
public protocol XvViewHoverDelegate:AnyObject {
    func hoverBegan(view:XvView)
    func hoverEnded(view:XvView)
}

public struct XvViewLocation {
    
    public init(local:CGPoint, global:CGPoint) {
        self.local = local
        self.global = global
    }
    public var local:CGPoint
    public var global:CGPoint
}

//class with x, y, width, height, etc...

open class XvView:Equatable {
    
    //Equatable comparison - use the timestamp ID
    public static func == (lhs: XvView, rhs: XvView) -> Bool {
        return lhs.timestampID == rhs.timestampID
    }
    
    internal var _view:UIView
    internal var _shapeLayer:CAShapeLayer
    fileprivate let timestampID:Double

    public init(
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat)
    {
        
        //unique ID so item can be equatable
        timestampID = Date().timeIntervalSince1970
        
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
        
        //showBoundingBox()
    }

    //MARK: Frame
    public var view:UIView {
        get { return _view }
        set { _view = newValue }
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
    
    public var visible:Bool {
        get { return !view.isHidden }
        set { view.isHidden = !newValue }
    }

    
    //climb up ladder of views to get the root view
    public var rootView:UIView {
        
        get {
            
            var v:UIView = self.view
            while let s = v.superview {
                v = s
            }
            return v
        }
    }
    
    //call when changing size of XvShape and need gradients and sublayers to resize too
    open func refreshSize(){
        
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
    public func showBoundingBox(color:UIColor = UIColor.red){
        
        _view.layer.borderColor = color.cgColor
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
        drag!.minimumPressDuration = 0.125
        
        view.addGestureRecognizer(drag!)
        view.isUserInteractionEnabled = true
    }
    
    
    @objc func viewDragged(){
        
        if (drag != nil) {
            
            //get global loc of frame
            if let globalPoint:CGPoint = view.superview?.convert(
                view.frame.origin, to: nil
            ) {
                
                //relative xy of click inside the view
                let localPoint:CGPoint = drag!.location(in: view)
                
                //calc global by add local xy to global frame xy
                let viewInGlobal:CGPoint = CGPoint(
                    x: globalPoint.x + localPoint.x,
                    y: globalPoint.y + localPoint.y
                )
                
                //create custom loc object with both
                let location:XvViewLocation = XvViewLocation(
                    local: localPoint,
                    global: viewInGlobal
                )
                
                //send out to delegate
                if (drag!.state == .began) {
                    
                    dragDelegate?.dragBegan(view: self, location: location)
                    
                } else if (drag!.state == .changed) {
                    
                    dragDelegate?.dragging(view: self, location: location)
                
                } else if (drag!.state == .ended) {
                    
                    dragDelegate?.dragEnded(view: self, location: location)
                }
            }
        }
    }
    
    
    //MARK: Hover
    
  
    public func addHover(delegate:XvViewHoverDelegate){
        
        //pass down to sub class
        if #available(iOS 13.0, *) {
            XvViewHover.sharedInstance.set(view: self)
            XvViewHover.sharedInstance.addHover(delegate: delegate)
        } else {
            // Fallback on earlier versions
            print("XvView: addHover: This is only available of iOS 13 or later")
        }
    }
    
    @objc func viewHovered(){
        
        //pass down to sub class
        if #available(iOS 13.0, *) {
            XvViewHover.sharedInstance.viewHovered()
        } else {
            // Fallback on earlier versions
            print("XvView: viewHovered: This is only available of iOS 13 or later")
        }
    }
    

}

@available(iOS 13.0, *)
class XvViewHover {
    
    fileprivate var _hover:UIHoverGestureRecognizer?
    fileprivate var _view:XvView?
    fileprivate var _delegate:XvViewHoverDelegate?
    
    //singleton code
    public static let sharedInstance = XvViewHover()
    fileprivate init() {}
    
    func set(view:XvView) {
        self._view = view
    }
    
    func addHover(delegate:XvViewHoverDelegate){
        
        if (_view != nil) {
            
            //if existing, clear it
            if (_hover != nil) {
                _view!.view.removeGestureRecognizer(_hover!)
                _hover = nil
                _delegate = nil
            }
            
            //re-create it
            _delegate = delegate
            _hover = UIHoverGestureRecognizer(
                target: self,
                action: #selector(viewHovered)
            )
            
            _view!.view.addGestureRecognizer(_hover!)
            _view!.view.isUserInteractionEnabled = true
        } else {
            print("XvViewHover: addHover: Error: XvView or XvViewHoverDelegate is nil")
        }
    }
    
    @objc func viewHovered(){
        
        if (_view != nil && _delegate != nil && _hover != nil) {
        
            if (_hover!.state == .began) {
                
                _delegate?.hoverBegan(view: _view!)
            
            } else if (_hover!.state == .ended) {
                
                _delegate?.hoverEnded(view: _view!)
            }
        } else {
            print("XvViewHover: viewHovered: Error: XvView or XvViewHoverDelegate or UIHoverGestureRecognizer is nil")
        }
    }
    
}
