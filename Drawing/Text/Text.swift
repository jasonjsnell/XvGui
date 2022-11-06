//
//  TextFormatter.swift
//  Refraktions
//
//  Created by Jason Snell on 3/10/16.
//  Copyright © 2016 Jason J. Snell. All rights reserved.
//


#if os(iOS)
import UIKit
#else
import AppKit
#endif


//MARK: - Public Methods -

public class Text{
    
    //Library of fonts used in apps
    public static let HELV_NEUE:String = "HelveticaNeue"
    public static let HELV_NEUE_CON_BOLD:String = "HelveticaNeue-CondensedBold"
    public static let HELV_REGULAR:String = "Helvetica"
    public static let HELV_BOLD:String = "Helvetica-Bold"
    
    
    //MARK: CREATE
    //no font passed in
    public static func createLabel(
        text:String,
        color:UIColor,
        size:CGFloat,
        alignment:NSTextAlignment) -> UILabel? {
        
        if let _:UIFont = UIFont(name: "HelveticaNeue", size: UIFont.systemFontSize) {
            return createLabel(text: text, fontName: "HelveticaNeue", color:color, size: size, alignment: alignment)
        } else {
            return nil
        }
        
    }
    
    //no color passed in
    public static func createLabel(
        text:String,
        fontName:String,
        size:CGFloat,
        alignment:NSTextAlignment) -> UILabel? {
        
        let defaultColor:UIColor = UIColor.white
        return createLabel(text: text, fontName: fontName, color: defaultColor, size: size, alignment: alignment)
        
    }
    
    //complete function
    public static func createLabel(
        text:String,
        fontName:String,
        color:UIColor,
        size:CGFloat,
        alignment:NSTextAlignment) -> UILabel? {
        
        //debug
        //let _:Bool = isFontValid(fontName: fontName)
        
        //create font and see if there is an error
        if let font:UIFont = UIFont(name: fontName, size: size){
            
            let label:UILabel = UILabel()
            
            //set text
            set(label:label, withText:text)
            
            //font created, format it
            label.font = font
            label.textColor = color
            label.textAlignment = alignment
            
            //default position 0, 0
            label.frame = CGRect(
                x: 0, y: 0,
                width: label.intrinsicContentSize.width,
                height: label.intrinsicContentSize.height)
            
            return label
            
        } else {
            
            print("TEXT: Font not found, returning nil")
            return nil
        }
    }
    
    //MARK: POSITION
    
    public static func getX(of label:UILabel) -> CGFloat {
        return label.frame.origin.x
    }
    
    public static func getY(of label:UILabel) -> CGFloat {
        return label.frame.origin.y
    }
    
    public static func getWidth(of label:UILabel) -> CGFloat {
        return label.intrinsicContentSize.width
    }
    
    public static func getHeight(of label:UILabel) -> CGFloat {
        return label.intrinsicContentSize.height
    }
    
    public static func position(label:UILabel, x:CGFloat, centered:Bool) {
        
        let y:CGFloat = getY(of: label)
        position(label: label, x: x, y: y, centered: centered)
    }
    
    public static func position(label:UILabel, y:CGFloat, centered:Bool) {
        
        let x:CGFloat = getX(of: label)
        position(label: label, x: x, y: y, centered: centered)
    }
    
    public static func position(label:UILabel, x:CGFloat, y:CGFloat, centered:Bool){
        
        label.frame = CGRect(
            x: x, y: y,
            width: label.intrinsicContentSize.width,
            height: label.intrinsicContentSize.height
        )
        
        if (centered){
            let centerPoint:CGPoint = CGPoint(x: x, y: y)
            label.center = centerPoint
        }
        
    }
    
    //MARK: SET TEXT
    public static func set(label:UILabel, withText:String, centered:Bool = false){
        
        //get center point before the text update
        let center:CGPoint = label.center
        
        //update the text
        label.text = withText
        
        //update the frame to reflect new text size
        label.frame = CGRect(
            x: getX(of: label),
            y: getY(of: label),
            width: label.intrinsicContentSize.width,
            height: label.intrinsicContentSize.height
        )
        
        //center the text using the original center point
        if (centered){
            label.center = center
        }
        
    }
    
    //MARK: VALIDITY TEST
    public static func isFontValid(fontName:String) -> Bool {
        
        //check to see if font is in the system
        
        for familyName in UIFont.familyNames {
            
            print("\n-- \(familyName) \n")
            
            for name in UIFont.fontNames(forFamilyName: familyName) {
                
                print(name)
                
                if (fontName == name){
                    print("TEXT:", fontName, "is valid")
                    return true
                }
            }
        }
        
        print("TEXT:", fontName,"is invalid, do not display")
        return false
    }
    
}
