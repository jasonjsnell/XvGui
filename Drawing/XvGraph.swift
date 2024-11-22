//
//  XvGraph.swift
//  XvGui
//
//  Created by Jason Snell on 10/17/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif



import XvUtils

public class XvGraph:UIView {
    
    public static let scaleLinear:String = "scaleLinear"
    public static let scaleLogarithmic:String = "scaleLogarithmic"
    
    public static let alignmentLeftRight:String = "alignmentLeftRight"
    public static let alignmentRightLeft:String = "alignmentRightLeft"
    public static let alignmentInsideOut:String = "alignmentInsideOut"
    public static let alignmentOutsideIn:String = "alignmentOutsideIn"
    
    //MARK: - Accessors
    fileprivate var _scale:String = XvGraph.scaleLinear
    public var scale:String {
        get {
            return _scale
        }
        set {
            _scale = newValue
        }
    }
    
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
            _zeroBaselinePct = _zeroBaseline / _graphH
        }
    }
    fileprivate var _bottomFill:Bool
    public var bottomFill:Bool {
        get { return _bottomFill }
        set { _bottomFill = newValue }
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
        for line in lines { addSubview(line.view) }
    }
    
    //getter
    public var lines:[XvLine] {
        get { return _lines }
    }
    
    //dimensions
    
    fileprivate var _graphH:CGFloat
    fileprivate var _graphW:CGFloat
    
    //logarithmic calculations
    fileprivate let logScale:LogarithmicScaling

    //MARK: - Init -
    override init(frame: CGRect = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)) {
       
        //default baseline is middle of frame
        _zeroBaseline = Screen.height / 2
        _zeroBaselinePct = _zeroBaseline / Screen.height
        
        //default is the bottom is not filled, no fill color
        _bottomFill = false
        
        //amplifier - how much to magnify values in points array
        _amplifier = 1.0
        
        //capture vars locally for faster rendering
        _graphW = Screen.width
        _graphH = Screen.height
   
        //default alignment is left to right
        _alignment = XvGraph.alignmentLeftRight
        
        logScale = LogarithmicScaling(
            outputRange: Int(Screen.width),
            smoothing: true
        )
        
        super.init(frame: frame)
        
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
    public func refreshSize(x:CGFloat = 0, y:CGFloat = 0, w:CGFloat = Screen.width, h:CGFloat = Screen.height){
        
        //update frame
        _graphW = w
        _graphH = h
        self.frame =  CGRect(x: x, y: y, width: w, height: h)
        _zeroBaseline = _graphH * _zeroBaselinePct
        logScale.outputRange = Int(_graphW)
     
    }
    
    //MARK: Refresh Data
    fileprivate var _yDataSets:[[CGFloat]] = []
    
    //just send in one dataset
    public func refresh(withYDataSet:[CGFloat]) {
        
        //clear set
        _yDataSets = []
        
        if (scale == XvGraph.scaleLinear) {
            
            //single, linerar set
            _yDataSets.append(withYDataSet)
            
        } else {
           
            //init a blank array that will replace the set array
            _yDataSets.append(logScale.scaleCG(dataSet: withYDataSet))
        }
        
        refresh()
    }
    
    //send in multiple sets to render multiple lines
    public func refresh(withYDataSets:[[CGFloat]]) {
        
        _yDataSets = []
        
        if (withYDataSets.count == _lines.count) {
            
            _yDataSets = withYDataSets
            
        } else {
            
            print("XvGraph: withYDataSets quantity", withYDataSets.count, "is more than the quantity", _lines.count, "of lines")
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
            
            //grab set and line
            let set:[CGFloat] = _yDataSets[i]
            let line:XvLine = _lines[i]
            
            //no data is in data point set yet
            if (set.count < 2) { return }
            
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
        let xInc:CGFloat = _graphW / CGFloat(yDataSet.count-1)
        let reversedData:[CGFloat] = yDataSet.reversed()
        _render(line: line, yDataSet: reversedData, xInc: xInc)
    }
    
    fileprivate func renderRightLeft(line:XvLine, yDataSet:[CGFloat]) {
    
        //data points will animate from right to left
        //meaning data array will be applied left to right
        let xInc:CGFloat = _graphW / CGFloat(yDataSet.count-1)
        _render(line: line, yDataSet: yDataSet, xInc: xInc)
    }
    
    fileprivate func renderOutsideIn(line:XvLine, yDataSet:[CGFloat]) {
        
        //data points animate from the outside to center
        
        let xInc:CGFloat = (_graphW / 2) / CGFloat(yDataSet.count-1)
        
        let reversedData:[CGFloat] = yDataSet.reversed()
        let doubledData:[CGFloat] = reversedData + yDataSet
        
        _render(line: line, yDataSet: doubledData, xInc: xInc)
        
    }
    
    fileprivate func renderInsideOut(line:XvLine, yDataSet:[CGFloat]) {
        
        //data points animate from the inside out
        let xInc:CGFloat = (_graphW / 2) / CGFloat(yDataSet.count-1)
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
        
        //have the fill extend to the bottom of the screen
        //the lines require a fill in this mode
        if (_bottomFill) {
            let lineEnd:CGPoint = CGPoint(x: xLoc, y: getY(from: yDataSet.last!))
            let lowerRightCorner:CGPoint = CGPoint(x: xLoc, y: Screen.height)
            let lowerLeftCorner:CGPoint = CGPoint(x: 0, y: Screen.height)
            let lineStart:CGPoint = CGPoint(x: 0, y: getY(from: yDataSet[0]))
            points.append(lineEnd)
            points.append(lowerRightCorner)
            points.append(lowerLeftCorner)
            points.append(lineStart)
        }
        
        //pass completed array into the XvLine for rendering
        line.update(points: points)
    }
    
    fileprivate func getY(from y:CGFloat) -> CGFloat {
        
        let scaledY:CGFloat = y * amplifier
        return _zeroBaseline - scaledY
    }
}
