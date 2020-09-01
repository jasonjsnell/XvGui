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
    
    public class func getUIColor(fromRGBA:[CGFloat]) -> UIColor {
        
        let uiColor:UIColor = UIColor(
            red: fromRGBA[0],
            green: fromRGBA[1],
            blue: fromRGBA[2],
            alpha: fromRGBA[3]
        )
        
        return uiColor
    }
    
    public class func getUIColor(fromRGB:[CGFloat], alpha:CGFloat) -> UIColor {
        
        let uiColor:UIColor = UIColor(
            red: fromRGB[0],
            green: fromRGB[1],
            blue: fromRGB[2],
            alpha: alpha
        )
        
        return uiColor
    }
    
    public class func getCGColor(fromRGBA:[CGFloat]) -> CGColor {
        
        return getUIColor(fromRGBA: fromRGBA).cgColor
    }
    
    public class func getCGColor(fromRGB:[CGFloat], alpha:CGFloat) -> CGColor {
        
        return getUIColor(fromRGB: fromRGB, alpha: alpha).cgColor
    }

    
    public class func getUIColor(fromHex:String) -> UIColor {
        
        //clean up incoming string
        var hex:String = fromHex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        
        //confirm length
        if (hex.count != 6) {
            print("Color: Error: Incoming hex is not 6-digit. Returning .clear")
            return .clear
        }
        
        //init rgb values
        var rgb:UInt64 = 0
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        
        //convert hex to rgb
        guard Scanner(string: hex).scanHexInt64(&rgb) else {
            print("Color: Error: Unable to convert hex to UIColor. Returning .clear")
            return .clear
        }
        
        r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        b = CGFloat( rgb & 0x0000FF) / 255.0
        
        //return color
        return UIColor(
            red:   r,
            green: g,
            blue:  b,
            alpha: 1.0
        )
    }
}
