//
//  Grid.swift
//  XvGui
//
//  Created by Jason Snell on 8/28/19.
//  Copyright © 2019 Jason Snell. All rights reserved.
//

import UIKit

public class Grid {
    
    public class func getBlankGrid(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) -> UIView {
        
        return UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    }
    
    public class func build(grid:UIView, withObjects:[UIViewController], objectsPerRow:Int, xInc:CGFloat, yInc:CGFloat) {

        var buildX:CGFloat = 0
        var buildY:CGFloat = 0
        
        var rowNum:Int = 0
        var colNum:Int = 0
        
        for i in 0 ..< withObjects.count {
            
            buildX = xInc * CGFloat(colNum)
            buildY = yInc * CGFloat(rowNum)
            
            let objectView:UIView = withObjects[i].view
            Shapes.set(x: buildX, y: buildY, ofView: objectView)
            grid.addSubview(objectView)
           
            colNum += 1
            if (colNum >= objectsPerRow){
                colNum = 0
                rowNum += 1
            }
            
        }
    
    }
}
