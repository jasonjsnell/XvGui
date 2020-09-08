//
//  TextFormatter.swift
//  Refraktions
//
//  Created by Jason Snell on 3/10/16.
//  Copyright © 2016 Jason J. Snell. All rights reserved.
//


import UIKit

//MARK: - Input Text -
public class XvInputText {

    fileprivate let _textField:UITextView
    
    public init(
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        width:CGFloat,
        height:CGFloat,
        
        //text properties
        text:String = "",
        textColor:UIColor = .black,
        fontName:String = Text.HELV_NEUE,
        size:CGFloat = UIFont.systemFontSize,
        
        //background properties
        backgroundColor:UIColor = .white,
        borderColor:UIColor = .black,
        borderWidth:CGFloat = 2.0,
        cornerRadius:CGFloat = 8.0,
        
        //delegate
        delegate:UITextViewDelegate? = nil
        ){
        
        //init object
        _textField = UITextView(frame: CGRect(
            x: x,
            y: y,
            width: width,
            height: height)
        )
        
        if let font:UIFont = UIFont(name: fontName, size: size){
        
            _textField.font = font
            
        } else {
            print("XvInputText: Error: Unable to find font when creating input text")
        }
        
        //assign incoming vars
        _textField.text = text
        _textField.textColor = textColor
        _textField.backgroundColor = backgroundColor
        _textField.layer.borderColor = borderColor.cgColor
        _textField.layer.borderWidth = borderWidth
        _textField.layer.cornerRadius = cornerRadius
        
        //assign delegate
        _textField.delegate = delegate
        
        //defaults
        _textField.tintColor = .black
        _textField.layer.masksToBounds = true;
        _textField.autocorrectionType = UITextAutocorrectionType.no
        _textField.keyboardType = UIKeyboardType.default
        _textField.returnKeyType = UIReturnKeyType.done
    
    }
    
    public var text:String? {
        get { return _textField.text }
        set { _textField.text = newValue }
    }
    
    public var view:UIView {
        get { return _textField }
    }
    
    public var x:CGFloat {
        get { return _textField.frame.origin.x }
        set { _textField.frame.origin.x = newValue }
    }
    
    public var y:CGFloat {
        get { _textField.frame.origin.y }
        set { _textField.frame.origin.y = newValue }
    }
    
    public var width:CGFloat {
        get { return _textField.frame.size.width }
        set {
            _textField.frame = CGRect(
                x: x,
                y: y,
                width: newValue,
                height: height
            )
        }
    }
       
    public var height:CGFloat {
        get { return _textField.frame.size.height }
        set {
            _textField.frame = CGRect(
                x: x,
                y: y,
                width: width,
                height: newValue
            )
        }
    }
    
}

//MARK: - XvText -
public class XvText{
    
    fileprivate var _view:UIView
    
    fileprivate var _label:UILabel?
    fileprivate var _fontName:String
    fileprivate var _color:UIColor
    fileprivate var _size:CGFloat
    fileprivate var _alignment:NSTextAlignment
    fileprivate var _centered:Bool
    
    fileprivate var _background:XvRect?
    fileprivate var _padding:CGFloat
    
    
    //init with standard values
    public init(
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        
        //text properties
        text:String = "",
        color:UIColor = .white,
        fontName:String = Text.HELV_NEUE,
        size:CGFloat = UIFont.systemFontSize,
        alignment:NSTextAlignment = .left,
        
        //background properties
        backgroundColor:UIColor? = nil,
        backgroundWidth:CGFloat? = nil,
        borderColor:UIColor? = nil,
        borderWidth:CGFloat = 0,
        cornerRadius:CGFloat = 0,
        padding:CGFloat = 0) {
        
        self._fontName = fontName
        self._color = color
        self._size = size
        self._alignment = alignment
        self._padding = padding
        
        _view = UIView(frame: CGRect(x: x, y: y, width: 0, height: 0))
        
        //deduct centered (whether label aligns to a middle point when changing xy)
        if (alignment == .center) {
            _centered = true
        } else {
            _centered = false
        }
        
        //turn "" into a space so the height is full
        var _text:String = text
        if (_text == "") { _text = " " }
        
        //try to create a label with incoming vars
        if let _lbl:UILabel = Text.createLabel(text: _text, fontName: fontName, color: color, size: size, alignment: alignment) {
            
            //if successful, save it
            _label = _lbl
            
            _label!.frame = CGRect(
                x: _padding,
                y: _padding,
                width: _label!.intrinsicContentSize.width,
                height: _label!.intrinsicContentSize.height
            )
            
            //then construct background
            var _backgroundColor:UIColor = .clear
            var _borderColor:UIColor = .clear
            
            if (backgroundColor != nil) {
                _backgroundColor = backgroundColor!
            }
            if (borderColor != nil) {
                _borderColor = borderColor!
            }
            
            //if background or border color are valid, make the bg
            if (backgroundColor != nil || borderColor != nil) {
                
                var w:CGFloat
                
                if (backgroundWidth != nil) {
                    
                    //set by incoming value
                    w = backgroundWidth!
                } else {
                    
                    //or created dynamically to be text width + padding
                    w = Text.getWidth(of: _label!) + (_padding * 2)
                }
                
                //bg height = text height + padding
                let h:CGFloat = Text.getHeight(of: _label!) + (_padding * 2)
                
                _background = XvRect(
                    x: 0,
                    y: 0,
                    width: w,
                    height: h,
                    bgColor: _backgroundColor,
                    borderColor: _borderColor,
                    borderWidth: borderWidth,
                    cornerRadius: cornerRadius
                )
                
                //resize main view to fit bg
                _view.frame = CGRect(x: x, y: y, width: w, height: h)
                _view.addSubview(_background!.view)
                
            } else {
                
                //else no background, size view to fit text
                _view.frame = CGRect(x: x, y: y, width: _label!.frame.width, height: _label!.frame.height)
                
            }
            
            //add text on top of background
            _view.addSubview(_label!)
           
            //refresh size now that every is added
            refreshSize()
            
        } else {
            print("XvText: Error: Unable to init label")
        }
        
    }
    
    public var text:String? {
        get { return _label!.text }
        set {
            _label?.text = newValue
            refreshSize()
        }
    }
    
    public var view:UIView {
        get { return _view }
    }
    
    public var x:CGFloat {
        get { return _view.frame.origin.x }
        set { _view.frame.origin.x = newValue }
    }
    
    public var y:CGFloat {
        get { return _view.frame.origin.y }
        set { _view.frame.origin.y = newValue }
    }
    
    public var xy:CGPoint {
        get { return _view.frame.origin }
        set { _view.frame.origin = newValue }
    }
    
    public var alpha:CGFloat {
        get { return _label!.alpha }
        set {
            var newAlpha:CGFloat = newValue
            if (newAlpha > 1.0) { newAlpha = 1.0 } else if (newAlpha < 0.0) { newAlpha = 0.0 }
            _view.alpha = newAlpha
        }
    }
    
    public var centered:Bool {
        get { return _centered }
    }
    
    public var width:CGFloat {
        get { return _view.frame.width }
        set {
            _view.frame = CGRect(x: x, y: y, width: newValue, height: height)
            if (_background != nil) { _background!.width = newValue }
            refreshSize()
        }
    }
    
    public var height:CGFloat {
        get { return _view.frame.height }
        set {
            _view.frame = CGRect(x: x, y: y, width: width, height: newValue)
            if (_background != nil) { _background!.height = newValue }
            refreshSize()
        }
    }
    
    public var textWidth:CGFloat {
        get { return _label!.frame.size.width }
    }
    
    public var textHeight:CGFloat {
        get { return _label!.frame.size.height }
    }
    
    public var backgroundWidth:CGFloat {
        get {
            if (_background != nil) {
                return _background!.width
            } else {
                return 0
            }
        }
        set {
            _background?.width = newValue //change the background width
            width = newValue //change the main view width (which also fires resize code
        }
    }
    
    public var backgroundHeight:CGFloat {
        get {
            if (_background != nil) {
                return _background!.height
            } else {
                return 0
            }
        }
        set {
            _background?.height = newValue //change the background height
            height = newValue //change the main view height (which also fires resize code
        }
    }
    
    //MARK: Resizing
    fileprivate func refreshSize(){
        
        //make sure label layout is correct after view has been resized
        
        //fit label view to text content
        _label!.frame = CGRect(
            x: _padding,
            y: _padding,
            width: _label!.intrinsicContentSize.width,
            height: _label!.intrinsicContentSize.height
        )
        
        //center the text if centering is true
        //centering is handled differently based on whether the text is on a background (center it on the bg) or whether text has no background (center it on the determined xy point
        
        if (_background != nil && _centered) {
          
            //background and centered text
            //shift the x point so the text field sits in the center of the background graphic
            _label!.frame = CGRect(
                x: (backgroundWidth/2) - (textWidth/2),
                y: _padding,
                width: _label!.intrinsicContentSize.width,
                height: _label!.intrinsicContentSize.height
            )
            
        } else if (_background == nil && _centered) {
                
            //no background, text centered around it's XY point
            _label!.center = CGPoint(x: x, y: y)
        
        }

    }
    
    
}



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
