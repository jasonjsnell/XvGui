//
//  XvLine.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

public class XvLine:XvView {
    
    fileprivate var _lineView:XvLineView
    
    //MARK: Init
    public init(
        lineWidth:CGFloat = 1.0,
        color:UIColor = .black,
        fill:UIColor? = nil,
        points:[CGPoint] = [],
        curved:Bool = false,
        closed:Bool = false,
        lineCapStyle:CGLineCap = .butt
        
    ){
        
        //pass vars down into the UIView
        _lineView = XvLineView(
            lineWidth: lineWidth,
            color: color,
            fill: fill,
            points: points,
            curved: curved,
            closed: closed,
            lineCapStyle: lineCapStyle
        )
        
        //super init a blank frame up to XvView
        //it will get updated during update points
        super.init(x: 0, y: 0, width: 0, height: 0)
        
        //turn the XvView's UIViw into a XvLineView
        self.view = _lineView
        
        //making holding view's bg transparent
        _view.backgroundColor = .clear
    }
    
    //MARK: Update property methods
    //use these inside or outside the UIView draw method
    public func update(lineWidth:CGFloat) { _lineView.bezierPath.lineWidth = lineWidth }
    public func update(color:UIColor) { _lineView.update(color: color) }
    public func update(fill:UIColor) { _lineView.update(fill: fill) }
    public func update(points:[CGPoint]) { _lineView.update(points: points) }
    
    public var bezierPath:UIBezierPath {
        get { _lineView.bezierPath }
    }
    public var points:[CGPoint] {
        get { _lineView.points }
    }
}

internal class XvLineView:UIView {
    
    fileprivate var _color:UIColor = UIColor.black
    fileprivate var _fill:UIColor?
    fileprivate var _closed:Bool = false
    fileprivate var _curved:Bool = false
    
    internal let bezierPath:UIBezierPath = UIBezierPath()
    internal var points:[CGPoint] = []
    
    //MARK: Init
    internal init(
        lineWidth:CGFloat = 1.0,
        color:UIColor = .black,
        fill:UIColor? = nil,
        points:[CGPoint] = [],
        curved:Bool = false,
        closed:Bool = false,
        lineCapStyle:CGLineCap = .butt
        
    ){
        
        //super.init frame as zero, then it gets expanded in the update(points) func
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        //update private attributes
        _closed = closed
        _curved = curved
        bezierPath.lineCapStyle = lineCapStyle
        
        //update public attributres
        update(lineWidth: lineWidth)
        update(color: color)
        if (fill != nil) { update(fill: fill!) }
        
        if (points.count > 1) {
            update(points: points)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //public accessors
    internal func update(lineWidth:CGFloat) {
        bezierPath.lineWidth = lineWidth
        setNeedsDisplay() //refresh view
    }
    
    internal func update(color:UIColor) {
        _color = color
        setNeedsDisplay() //refresh view
    }
    
    internal func update(fill:UIColor) {
        _fill = fill
        setNeedsDisplay() //refresh view
    }
    
    internal func update(points:[CGPoint]) {
        
        self.points = points
        
        if (points.count > 1) {
            
            bezierPath.removeAllPoints()//clear existing
            bezierPath.move(to: points[0]) //move to starting position
            
            //reset frame to encompass the furthest points in the incoming CGPoint array
            let xArray:[CGFloat] = points.map(\.x)
            let yArray:[CGFloat] = points.map(\.y)
            
            if let maxX:CGFloat = xArray.max(),
                let maxY:CGFloat = yArray.max() {
                
                //add line width to values so frame crop doesn't cut off thicker lines
                frame = CGRect(
                    x: 0, y: 0,
                    width: maxX + bezierPath.lineWidth,
                    height: maxY + bezierPath.lineWidth
                )
                
            } else {
                
                print("XvLineView: Error: Unable to get maxX or mayX from incoming CGPoints. Defaulting to full screen")
                frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)
            }
            

            if (_curved) {
                
                //curved paths
                //get control points
                if let controlPointsArray:[[CGPoint]] = Lines.getControlPoints(from: points) {
                    
                    for i in 1..<points.count { //go through array
                        
                        let wavePoint:CGPoint = points[i] //grab the points
                        let controlPoints:[CGPoint] = controlPointsArray[i-1] //and corresponding control points
                        
                        //curved path
                        bezierPath.addCurve(to: wavePoint, controlPoint1: controlPoints[0], controlPoint2: controlPoints[1])
                    }
                }
                
            } else {
                
                //straight lines
                for i in 1..<points.count {
                    bezierPath.addLine(to: points[i]) //loop through the rest of the points to draw the line
                }
            }
        } else {
            print("XvLineView: Error: Need 2 or more CGPoints to draw line")
        }
        
        setNeedsDisplay() //refresh view
        
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        //most basic commands for a render
        _color.setStroke() //set color
        bezierPath.stroke() //draw line
        
        //if fill has been supplied
        if (_fill != nil) {
            
            //closed path, filled shape
            _fill!.setFill()
            bezierPath.close()
            bezierPath.fill()
        
        } else if (_closed){
            bezierPath.close() //closed path, no fill
        }
    }
}
