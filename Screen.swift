//
//  Global.swift
//  Refraktions
//
//  Created by Jason Snell on 11/7/15.
//  Copyright © 2015 Jason J. Snell. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif
import XvUtils

public class Screen  {
    
    //MARK:VARS
    public static let ORIENTATION_LANDSCAPE:String = "orientationLandscape"
    public static let ORIENTATION_PORTRAIT:String = "orientationPortrait"
    
    //accessed by root VC when placing settings button
    public static let SETTINGS_BUTTON_SIZE:CGFloat = 50
    
    //MARK: DIMENSIONS
    
    public static var y:CGFloat {
        get {
            #if targetEnvironment(macCatalyst)
            
            return 0
            //return 28 // title bar in Mac Catalyst
            
            #else
            return 0 //iOS
            #endif
        }
    }
    public static var width:CGFloat {
        get {
            #if targetEnvironment(macCatalyst)
            
            if let firstWindow = UIApplication.shared.windows.first {
                if let rootViewControoler:UIViewController = firstWindow.rootViewController {
                    return rootViewControoler.view.frame.size.width
                }
            }
            
            print("Screen: Error: Unable to find rootViewController width")
            return 0
            
            #else
            return UIScreen.main.bounds.width
            #endif
        }
    }
    

    public static var height:CGFloat {
        get {
            #if targetEnvironment(macCatalyst)
            
            if let firstWindow:UIWindow = UIApplication.shared.windows.first {
                if let rootViewControoler:UIViewController = firstWindow.rootViewController {
                    return rootViewControoler.view.frame.size.height - Screen.y
                }
            }
            
            print("Screen: Error: Unable to find rootViewController height")
            return 0
            
            #else
            return UIScreen.main.bounds.height
            #endif
        }
    }
    
    public static var max:CGFloat {
        
        get {
            if (height > width){
                return height
            } else {
                return width
            }
        }
    }
    
    public static var min:CGFloat {
        
        get {
            if (width < height){
                return width
            } else {
                return height
            }
        }
    }
    
    //view port height
    public func v(h:CGFloat) -> CGFloat {
        return Screen.height * (h / 100)
    }
    
    //view port width
    public func v(w:CGFloat) -> CGFloat {
        return Screen.width * (w / 100)
    }
    
    public static var center:CGPoint {
        
        get {
            return CGPoint(x: width / 2, y: height / 2)
        }
    }
    
    public static var onScreenXZero:CGFloat {
        
        get {
            return (max / 2) - (width / 2)
        }
    }
    
    public static var onScreenYZero:CGFloat {
        
        get {
            return (max / 2) - (height / 2)
        }
    }
    
    
    
    //MARK:IMAGE SCALE
    public static var scale:CGFloat {
        
        get {
            return Number.getPercentage(
                value1: max,
                ofValue2: Device.SCREEN_MAX) / 100
        }
    }
    
    //MARK: ORIENTATION
    public static var orientation:String {
        
        get {
            if (height > width){
                return ORIENTATION_PORTRAIT
            } else {
                return ORIENTATION_LANDSCAPE
            }
        }
    }
    
    //MARK: ROWS, COLUMNS
    public static func getRowHeight(fromDivider: Int) -> CGFloat {
        return height / CGFloat(fromDivider)
    }
    
    public static func getColumnWidth(fromDivider:Int) -> CGFloat {
        return width / CGFloat(fromDivider)
    }
    
    //MARK: PCT OFFSETS
    //this is the percentage of screen real estate that is hidden on the shorter dimension of the layout
    public static var widthPercentageOffset:CGFloat {
        
        get {
            if (height > width){
                return getPercentageOffset
            } else {
                return 0
            }
        }
    }
    
    public static var heightPercentageOffset:CGFloat {
        
        get {
            if (width > height){
                return getPercentageOffset
            } else {
                return 0
            }
        }
    }
    
    //convert percentages into screen locations based on current screen size
    public static func getCGPoints(fromPercentageLocationArray:[[CGFloat]]) -> [CGPoint] {
        
        var cgPoints:[CGPoint] = []
        
        for percentageLocation in fromPercentageLocationArray {
            
            cgPoints.append(getCGPoint(fromPercentageLocation: percentageLocation))
            
        }
        
        return cgPoints
    }
    
    
    //private helpers
    public static func getCGPoint(fromPercentageLocation:[CGFloat]) -> CGPoint {
        
        let xPct:CGFloat = fromPercentageLocation[0]
        let yPct:CGFloat = fromPercentageLocation[1]
        
        let xLoc:CGFloat = Number.get(
            percentage: xPct,
            ofValue: max
        )
        
        let yLoc:CGFloat = Number.get(
            percentage: yPct,
            ofValue: max
        )
        
        return CGPoint(x:xLoc, y:yLoc)
        
    }
    
    
    fileprivate static var getPercentageOffset:CGFloat {
        return Number.getPercentage(value1: ((max-min) / 2), ofValue2: max)
    }
    
}
