//
//  XvGrid.swift
//  XvGui
//
//  Created by Jason Snell on 11/8/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

public class XvGrid:XvCompositeShape {
    
    public static let ALIGN_LEFT:String = "alignLeft"
    public static let ALIGN_RIGHT:String = "alignRight"
    public static let ALIGN_CENTER:String = "alignCenter"
    public static let ALIGN_TOP:String = "alignTop"
    public static let ALIGN_BOTTOM :String = "alignBottom"
    
    public var items:[XvView] = []
    
    fileprivate var maxWidth:CGFloat
    
    fileprivate let cellWidth:CGFloat
    fileprivate let cellHeight:CGFloat
    fileprivate let cellAlignHorizontal:String
    fileprivate let cellAlignVertical:String
    
    public init(
        x:CGFloat = 0,
        y:CGFloat = 0,
        maxWidth:CGFloat,
        items:[XvView],
        cellWidth:CGFloat,
        cellHeight:CGFloat,
        cellAlignHorizontal:String = XvGrid.ALIGN_LEFT,
        cellAlignVertical:String = XvGrid.ALIGN_TOP,
        horizontal:Bool = true
    ){
        
        self.maxWidth = maxWidth
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        self.cellAlignHorizontal = cellAlignHorizontal
        self.cellAlignVertical = cellAlignVertical
        
        super.init(x: x, y: y, width: 0, height: 0)
        
        add(items: items)
    }
    
    public func add(items:[XvView]) {
        
        //add to view
        for item in items {
            add(item)
        }
        
        //add to array
        self.items += items
        
        //render
        refreshSize()
    }
    
    public func remove(item:XvView) {
        
        if let index:Int = items.firstIndex(of: item) {
            
            //remove from array
            items.remove(at: index)
            
            //remove from view
            remove(item)
            
            //render
            refreshSize()
        }
    }
    
    public func insert(item:XvView, at:Int) {
        
        //insert into array
        items.insert(item, at: at)
        
        //add to view
        add(item)
        
        //render
        refreshSize()
    }
    
    public func getPosition(of item:XvView) -> Int? {
        
        if let index:Int = items.firstIndex(of: item) {
            return index
        }
        return nil
    }
    
    public func refreshSize(withNewMaxWidth:CGFloat) {
        self.maxWidth = withNewMaxWidth
        refreshSize()
    }
    
    public override func refreshSize() {
        
        super.refreshSize()
        
        var buildX:CGFloat = 0
        var largestX:CGFloat = 0
        var buildY:CGFloat = 0
        var gridHeight:CGFloat = 0
        
        for item in items {
            
            if ((buildX + cellWidth) > maxWidth) {
                largestX = maxWidth
                buildX = 0
                buildY += cellHeight
                if (buildY > gridHeight) { gridHeight = buildY }
            }
            
            //MARK: Alignment
            //where the item rests inside the cell area
            var xOffset:CGFloat = 0 //left side of cell
            
            if (cellAlignHorizontal == XvGrid.ALIGN_CENTER) {
                
                xOffset = (cellWidth - item.width) / 2 //middle of cell
                
            } else if (cellAlignHorizontal == XvGrid.ALIGN_RIGHT) {
                
                xOffset = (cellWidth - item.width) //right side of cell
            }
            
            var yOffset:CGFloat = 0 //top of cell
            
            if (cellAlignVertical == XvGrid.ALIGN_CENTER) {
                
                yOffset = (cellHeight - item.height) / 2 //middle of cell
                
            } else if (cellAlignVertical == XvGrid.ALIGN_BOTTOM) {
                
                yOffset = (cellHeight - item.height) //bottom of cell
            }
            
            item.x = buildX + xOffset
            item.y = buildY + yOffset
            
            buildX += cellWidth
            if (buildX > largestX) { largestX = buildX }
        }
        
        gridHeight += cellHeight
        
        //make sure width and height of grid view fits the items as they fill in, left to right, row after row
        self.width = largestX
        self.height = gridHeight
        
    }
    
    
}
