//
//  Lines.swift
//  XvGui
//
//  Created by Jason Snell on 6/12/19.
//  Copyright © 2019 Jason Snell. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

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
    
    public class func getControlPoints(from points:[CGPoint]) -> [[CGPoint]]? {
        
        /* usage
         
         let points:[CGPoint] = [array of CGPoints]
         let controlPointsArray:[[CGPoint]] = Lines.getControlPoints(from: points)
          
          let linePath = UIBezierPath()
          
          for i in 0..<points.count {
         
              let point = points[i];
              
              if i==0 {
                  linePath.move(to: point)
              } else {
                  let controlPoints:[CGPoint] = controlPointsArray[i-1]
                  linePath.addCurve(to: point, controlPoint1: controlPoints[0], controlPoint2: controlPoints[1])
              }
          }
         
         */
        
        var firstControlPoints: [CGPoint?] = []
        var secondControlPoints: [CGPoint?] = []
        
        //Number of Segments
        let count = points.count - 1
        
        if (count <= 0){
            
            return nil
            
        } else if count == 1 {
            
            //P0, P1, P2, P3 are the points for each segment, where P0 & P3 are the knots and P1, P2 are the control points.
            let P0 = points[0]
            let P3 = points[1]
            
            //Calculate First Control Point
            //3P1 = 2P0 + P3
            
            let P1x = (2*P0.x + P3.x)/3
            let P1y = (2*P0.y + P3.y)/3
            
            firstControlPoints.append(CGPoint(x: P1x, y: P1y))
            
            //Calculate second Control Point
            //P2 = 2P1 - P0
            let P2x = (2*P1x - P0.x)
            let P2y = (2*P1y - P0.y)
            
            secondControlPoints.append(CGPoint(x: P2x, y: P2y))
            
        } else {

            firstControlPoints = Array(repeating: nil, count: count)

            var rhsArray = [CGPoint]()
            
            //Array of Coefficients
            var a = [CGFloat]()
            var b = [CGFloat]()
            var c = [CGFloat]()
            
            for i in 0..<count {
                var rhsValueX: CGFloat = 0
                var rhsValueY: CGFloat = 0
                
                let P0 = points[i];
                let P3 = points[i+1];
                
                if i==0 {
                    a.append(0)
                    b.append(2)
                    c.append(1)
                    
                    //rhs for first segment
                    rhsValueX = P0.x + 2*P3.x;
                    rhsValueY = P0.y + 2*P3.y;
                    
                } else if i == count-1 {
                    a.append(2)
                    b.append(7)
                    c.append(0)
                    
                    //rhs for last segment
                    rhsValueX = 8*P0.x + P3.x;
                    rhsValueY = 8*P0.y + P3.y;
                } else {
                    a.append(1)
                    b.append(4)
                    c.append(1)
                    
                    rhsValueX = 4*P0.x + 2*P3.x;
                    rhsValueY = 4*P0.y + 2*P3.y;
                }
                
                rhsArray.append(CGPoint(x: rhsValueX, y: rhsValueY))
            }
            
            //Solve Ax=B. Use Tridiagonal matrix algorithm a.k.a Thomas Algorithm
            for i in 1..<count {
                let rhsValueX = rhsArray[i].x
                let rhsValueY = rhsArray[i].y
                
                let prevRhsValueX = rhsArray[i-1].x
                let prevRhsValueY = rhsArray[i-1].y
                
                let m = CGFloat(a[i]/b[i-1])
                
                let b1 = b[i] - m * c[i-1];
                b[i] = b1
                
                let r2x = rhsValueX - m * prevRhsValueX
                let r2y = rhsValueY - m * prevRhsValueY
                
                rhsArray[i] = CGPoint(x: r2x, y: r2y)
            }
            //Get First Control Points
            
            //Last control Point
            let lastControlPointX = rhsArray[count-1].x/b[count-1]
            let lastControlPointY = rhsArray[count-1].y/b[count-1]
            
            firstControlPoints[count-1] = CGPoint(x: lastControlPointX, y: lastControlPointY)
            
            for i in (0 ..< count - 1).reversed() {
                if let nextControlPoint = firstControlPoints[i+1] {
                    let controlPointX = (rhsArray[i].x - c[i] * nextControlPoint.x)/b[i]
                    let controlPointY = (rhsArray[i].y - c[i] * nextControlPoint.y)/b[i]
                    
                    firstControlPoints[i] = CGPoint(x: controlPointX, y: controlPointY)
                }
            }
            
            //Compute second Control Points from first
            
            for i in 0..<count {
                
                if i == count-1 {
                    let P3 = points[i+1]
                    
                    guard let P1 = firstControlPoints[i] else{
                        continue
                    }
                    
                    let controlPointX = (P3.x + P1.x)/2
                    let controlPointY = (P3.y + P1.y)/2
                    
                    secondControlPoints.append(CGPoint(x: controlPointX, y: controlPointY))
                    
                } else {
                    let P3 = points[i+1]
                    
                    guard let nextP1 = firstControlPoints[i+1] else {
                        continue
                    }
                    
                    let controlPointX = 2*P3.x - nextP1.x
                    let controlPointY = 2*P3.y - nextP1.y
                    
                    secondControlPoints.append(CGPoint(x: controlPointX, y: controlPointY))
                }
            }
        }
        
        var controlPoints = [[CGPoint]]()
        
        for i in 0..<count {
            if let firstControlPoint = firstControlPoints[i],
                let secondControlPoint = secondControlPoints[i] {
                let segment:[CGPoint] = [firstControlPoint, secondControlPoint]
                
                controlPoints.append(segment)
            }
        }
        
        return controlPoints
    }
    
}
