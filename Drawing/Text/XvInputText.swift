//
//  XvInputText.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//MARK: - Input Text -
public class XvInputText:XvView {

    fileprivate let _textField:UITextView
    
    public init(
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        width:CGFloat,
        height:CGFloat,
        
        //text properties
        text:String = "",
        textColor:UIColor? = nil,
        fontName:String = Text.HELV_NEUE,
        size:CGFloat = UIFont.systemFontSize,
        maxLines:Int = 0, //0 = no limit, 1 = 1 lines, 2 = 2 lines, etc
        
        //background properties
        backgroundColor:UIColor? = nil,
        borderColor:UIColor? = nil,
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
        
        if (textColor != nil) { _textField.textColor = textColor }
        _textField.textContainer.maximumNumberOfLines = maxLines
        if (backgroundColor != nil) { _textField.backgroundColor = backgroundColor }
        if (borderColor != nil) { _textField.layer.borderColor = borderColor?.cgColor }
        _textField.layer.borderWidth = borderWidth
        _textField.layer.cornerRadius = cornerRadius
        
        //assign delegate
        _textField.delegate = delegate
        
        //defaults
        _textField.tintColor = UIColor.clear
        _textField.tintColor = UIColor.red
        
        
        //_textField.layer.masksToBounds = true;
        //_textField.autocorrectionType = UITextAutocorrectionType.no
        //_textField.keyboardType = UIKeyboardType.default
        //_textField.returnKeyType = UIReturnKeyType.done
    
        _textField.text = text
        
        super.init(x: x, y: y, width: width, height: height)
        _view = _textField as UIView
    }
    
    
    public var text:String? {
        get { return _textField.text }
        set { _textField.text = newValue }
    }
    
}
