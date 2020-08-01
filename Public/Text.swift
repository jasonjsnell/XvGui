//
//  TextFormatter.swift
//  Refraktions
//
//  Created by Jason Snell on 3/10/16.
//  Copyright © 2016 Jason J. Snell. All rights reserved.
//


import UIKit

public class XvLabel{
    
    fileprivate var _label:UILabel?
    fileprivate var _text:String
    fileprivate var _fontName:String
    fileprivate var _color:UIColor
    fileprivate var _size:CGFloat
    fileprivate var _alignment:NSTextAlignment
    fileprivate var _centered:Bool
    
    //init with standard values
    public init(
        text:String = "",
        color:UIColor = .white,
        fontName:String = Text.HELV_NEUE,
        size:CGFloat = UIFont.systemFontSize,
        alignment:NSTextAlignment = .left) {
        
        self._text = text
        self._fontName = fontName
        self._color = color
        self._size = size
        self._alignment = alignment
        
        //deduct centered (whether label aligns to a middle point when changing xy)
        if (alignment == .center) {
            _centered = true
        } else {
            _centered = false
        }
        
        //try to create a label with incoming vars
        if let _lbl:UILabel = Text.createLabel(text: text, fontName: fontName, color: color, size: size, alignment: alignment) {
            
            //if successful, save it
            _label = _lbl
            
        } else {
            print("XvLabel: Error: Unable to init label")
        }
        
        
    }
    
    public var text:String {
        get { return _text }
        set { Text.set(label: _label!, withText: newValue, centered: _centered) }
    }
    
    public var view:UILabel {
        get { return _label! }
    }
    
    public var x:CGFloat {
        get { return Text.getX(of: _label!)}
        set { Text.position(label: _label!, x: newValue, centered: _centered)}
    }
    
    public var y:CGFloat {
        get { return Text.getY(of: _label!)}
        set { Text.position(label: _label!, y: newValue, centered: _centered)}
    }
    
    public var xy:CGPoint {
        get { return CGPoint(x: x, y: y) }
        set { Text.position(label: _label!, x: newValue.x, y: newValue.y, centered: _centered)}
    }
    
    public var alpha:CGFloat {
        get { return _label!.alpha }
        set {
            var newAlpha:CGFloat = newValue
            if (newAlpha > 1.0) { newAlpha = 1.0 } else if (newAlpha < 0.0) { newAlpha = 0.0 }
            _label!.alpha = newAlpha
        }
    }
    
    public var centered:Bool {
        get { return _centered }
        set { _centered = newValue }
    }
    
    
}

//MARK: - Static funcs to change a UILabel

public class Text{
    
    //MARK: Library of fonts used in apps
    public static let HELV_NEUE:String = "HelveticaNeue"
    public static let HELV_NEUE_CON_BOLD:String = "HelveticaNeue-CondensedBold"
    public static let HELV_REGULAR:String = "Helvetica"
    public static let HELV_BOLD:String = "Helvetica-Bold"
    
    
    //MARK: - PUBLIC API -
    
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
    
    public static func position(label:UILabel, x:CGFloat, centered:Bool) {
        
        let y:CGFloat = getY(of: label)
        position(label: label, x: x, y: y, centered: centered)
    }
    
    public static func position(label:UILabel, y:CGFloat, centered:Bool) {
        
        let x:CGFloat = getX(of: label)
        position(label: label, x: x, y: y, centered: centered)
    }
    
    public static func position(label:UILabel, x:CGFloat, y:CGFloat, centered:Bool){
        
        label.frame = CGRect(x: x, y: y, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        
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
