//
//  Lines.swift
//  XvGui
//
//  Created by Jason Snell on 6/12/19.
//  Copyright © 2019 Jason Snell. All rights reserved.
//

import UIKit

public class Lines {
    
    public class func createQuadCurvedPathWithPoints(points:[CGPoint]) -> UIBezierPath {
        
        //create path
        let path:UIBezierPath = UIBezierPath()
        
        //create first poont
        var p1:CGPoint = points[0]
        
        //move path to it
        path.move(to: p1)
        
        //if only 2 points, draw a straight line
        if (points.count == 2) {
            let p2:CGPoint = points[1]
            path.addLine(to: p2)
            return path
        }
        
        //sub functions for processing loop below
        func midPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
            return CGPoint(x:(p1.x + p2.x) / 2, y:(p1.y + p2.y) / 2)
        }
        
        func controlPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
            
            var controlPoint:CGPoint = midPointForPoints(p1: p1, p2: p2)
            let diffY:CGFloat = abs(p2.y - controlPoint.y)
            
            if (p1.y < p2.y) {
                controlPoint.y += diffY
            } else if (p1.y > p2.y) {
                controlPoint.y -= diffY
            }
            
            return controlPoint
        }
        
        //loop through points
        for i in 1 ..< points.count {
            
            //grab next point
            let p2:CGPoint = points[i]
            
            //create mid point
            let midPoint:CGPoint = midPointForPoints(p1: p1, p2: p2)
            
            //add curves
            path.addQuadCurve(to: midPoint, controlPoint: controlPointForPoints(p1: midPoint, p2: p1))
            path.addQuadCurve(to: p2, controlPoint: controlPointForPoints(p1: midPoint, p2: p2))
            
            //advance the loop to next point
            p1 = p2;
            
        }
        
        //return the curved path
        return path
    }
    
}
