//
//  XvGraph.swift
//  XvGui
//
//  Created by Jason Snell on 10/17/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

public class XvGraph:UIView {
    
    public static let alignmentLeftRight:String = "alignmentLeftRight"
    public static let alignmentRightLeft:String = "alignmentRightLeft"
    public static let alignmentInsideOut:String = "alignmentInsideOut"
    public static let alignmentOutsideIn:String = "alignmentOutsideIn"
    
    //MARK: - Accessors
    fileprivate var _amplifier:CGFloat
    public var amplifier:CGFloat {
        get { return _amplifier }
        set { _amplifier = newValue }
    }
    
    fileprivate var _zeroBaseline:CGFloat
    fileprivate var _zeroBaselinePct:CGFloat
    public var zeroBaseline:CGFloat {
        get { return _zeroBaseline }
        set {
            _zeroBaseline = newValue
            _zeroBaselinePct = _zeroBaseline / Screen.height
        }
    }
    
    fileprivate var _alignment:String
    public var alignment:String {
        get { return _alignment }
        set { _alignment = newValue }
    }
    
    fileprivate var _lines:[XvLine] = []
    
    //MARK: - add lines
    public func add(line:XvLine) {
        _lines.append(line)
        addSubview(line.view)
    }
    public func add(lines:[XvLine]) {
        
        _lines += lines
        
        for line in lines {
            addSubview(line.view)
        }
        
    }
    
    fileprivate var _screenH:CGFloat
    fileprivate var _screenW:CGFloat
    
    //MARK: - Init -
    override init(frame: CGRect) {
       
        //default baseline is middle of frame
        _zeroBaseline = Screen.height / 2
        _zeroBaselinePct = _zeroBaseline / Screen.height
        
        //amplifier - how much to magnify values in points array
        _amplifier = 1.0
        
        //capture vars locally for faster rendering
        _screenW = Screen.width
        _screenH = Screen.height
        
        //default alignment is left to right
        _alignment = XvGraph.alignmentLeftRight
        
        super.init(frame:
            CGRect(x: 0, y: 0, width: _screenW, height: _screenH)
        )
        
        //make bg color clear
        self.backgroundColor = UIColor.clear
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("This class does not support NSCoding") }
    
    
    //MARK: - Refresh -
    //MARK: Refresh View
    public func refresh(){
        
        //refresh display
        setNeedsDisplay()
    }
    
    //MARK: Refresh Size
    public func refreshSize(w:CGFloat = Screen.width, h:CGFloat = Screen.height){
        
        //update frame
        _screenW = w
        _screenH = h
        self.frame =  CGRect(x: 0, y: 0, width: w, height: h)
        _zeroBaseline = _screenH * _zeroBaselinePct
    }
    
    //MARK: Refresh Data
    fileprivate var _yDataSets:[[CGFloat]] = []
    
    //just send in one dataset
    public func refresh(withYDataSet:[CGFloat]) {
        
        _yDataSets = []
        _yDataSets.append(withYDataSet)
        refresh()
    }
    
    //send in multiple sets to render multiple lines
    public func refresh(withYDataSets:[[CGFloat]]) {
        
        _yDataSets = []
        
        if (withYDataSets.count == _lines.count) {
            
            _yDataSets = withYDataSets
            
        } else {
            
            print("XvGraph: Quantity", withYDataSets.count, "is more than the quanity", _lines.count, "of lines")
            _yDataSets = []
        }
        
        refresh()
    }
    
    //MARK: - RENDER -
    override public func draw(_ rect: CGRect) {
        
        //Error checking
        //no data points are available to render
        if (_yDataSets.count == 0 ) {
            return
        }
        
        if (_yDataSets.count > _lines.count) {
            print("XvGraph: Quantity", _yDataSets.count, "is more than the quanity", _lines.count, "of lines")
            return
        }
        
        //loop through each
        for i in 0..<_yDataSets.count {
            
            //grab set
            let set:[CGFloat] = _yDataSets[i]
            let line:XvLine = _lines[i]
            
            //no data is in data point set yet
            if (set.count == 0) { return }
            
            //render based on alignment
            
            switch _alignment {
            
            case XvGraph.alignmentLeftRight:
                renderLeftRight(line: line, yDataSet: set)

            case XvGraph.alignmentRightLeft:
                renderRightLeft(line: line, yDataSet: set)

            case XvGraph.alignmentInsideOut:
                renderInsideOut(line: line, yDataSet: set)
                
            case XvGraph.alignmentOutsideIn:
                renderOutsideIn(line: line, yDataSet: set)

            default:
                print("XvGraph: Error: Alignment", _alignment, "not recognized")
            }
        }
    }
    
    fileprivate func renderLeftRight(line:XvLine, yDataSet:[CGFloat]) {
        
        //data points will animate left to right
        //meaning data array will be applied right to left
        let xInc:CGFloat = _screenW / CGFloat(yDataSet.count-1)
        let reversedData:[CGFloat] = yDataSet.reversed()
        _render(line: line, yDataSet: reversedData, xInc: xInc)
    }
    
    fileprivate func renderRightLeft(line:XvLine, yDataSet:[CGFloat]) {
    
        //data points will animate from right to left
        //meaning data array will be applied left to right
        let xInc:CGFloat = _screenW / CGFloat(yDataSet.count-1)
        _render(line: line, yDataSet: yDataSet, xInc: xInc)
    }
    
    fileprivate func renderOutsideIn(line:XvLine, yDataSet:[CGFloat]) {
        
        //data points animate from the outside to center
        
        let xInc:CGFloat = (_screenW / 2) / CGFloat(yDataSet.count-1)
        
        let reversedData:[CGFloat] = yDataSet.reversed()
        let doubledData:[CGFloat] = reversedData + yDataSet
        
        _render(line: line, yDataSet: doubledData, xInc: xInc)
        
    }
    
    fileprivate func renderInsideOut(line:XvLine, yDataSet:[CGFloat]) {
        
        //data points animate from the inside out
        
        let xInc:CGFloat = (_screenW / 2) / CGFloat(yDataSet.count-1)
        
        let reversedData:[CGFloat] = yDataSet.reversed()
        let doubledData:[CGFloat] = yDataSet + reversedData
        
        _render(line: line, yDataSet: doubledData, xInc: xInc)
        
    }
    
    //main rendering code
    fileprivate func _render(
        line:XvLine,
        yDataSet:[CGFloat],
        xInc:CGFloat
    ) {
        
        var xLoc:CGFloat = 0
        var points:[CGPoint] = []
        
        // loop through y data set
        for i in 0 ..< yDataSet.count {
            
            //convert data point into screen location
            //and add to points array
            points.append(
                CGPoint(
                    x: xLoc,
                    y: getY( from: yDataSet[i] )
                )
            )
            
            //move x for the next render
            //xInc can be negative for right to left movement
            xLoc += xInc
        }
        
        //pass completed array into the XvLine for rendering
        line.update(points: points)
    }
    
    fileprivate func getY(from y:CGFloat) -> CGFloat {
        
        let scaledY:CGFloat = y * amplifier
        return _zeroBaseline - scaledY
    }
}