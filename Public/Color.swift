//
//  Colors.swift
//  XvGui
//
//  Created by Jason Snell on 4/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

public class Color {
    
    public class func getRGBA(fromUIColor:UIColor) -> [CGFloat] {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        fromUIColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
    
    public class func getRGBA(fromCGColor:CGColor) -> [CGFloat] {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let uiColor:UIColor = UIColor(cgColor: fromCGColor)

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
    
    public class func get(uiColor:UIColor, withAlpha:CGFloat) -> UIColor {
        
        let rgba:[CGFloat] = getRGBA(fromUIColor: uiColor)
        
        return UIColor (
            red: rgba[0],
            green: rgba[1],
            blue: rgba[2],
            alpha: withAlpha
        )
    }
    
    public class func get(cgColor:CGColor, withAlpha:CGFloat) -> CGColor {
        
        let rgba:[CGFloat] = getRGBA(fromCGColor: cgColor)
        
        let uiColor:UIColor = UIColor(
            red: rgba[0],
            green: rgba[1],
            blue: rgba[2],
            alpha: withAlpha
        )
        
        return uiColor.cgColor
    }

}
