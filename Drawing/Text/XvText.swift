//
//  XvText.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//MARK: - XvText -
public class XvText:XvView{
    
    fileprivate var _label:UILabel?
    fileprivate var _fontName:String
    fileprivate var _color:UIColor
    fileprivate var _size:CGFloat
    fileprivate var _alignment:NSTextAlignment
    
    fileprivate var _background:XvRect?
    fileprivate var _padding:CGFloat
    
    
    //init with standard values
    public init(
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        width:CGFloat = 0,
        height:CGFloat = 0,
        
        //text properties
        text:String = "",
        color:UIColor = .label,
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
        
        super.init(x: x, y: y, width: width, height: height)
        
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
    
    public var alignment:NSTextAlignment {
        get { return _alignment }
    }
    
    override public var width:CGFloat {
        get {
            if (_background != nil) {
                return _background!.width
            } else {
                return _label!.frame.size.width
            }
        }
        set {
            super.width = newValue
            if (_background != nil) { _background!.width = newValue }
            refreshSize()
        }
    }
    
    override public var height:CGFloat {
        get {
            if (_background != nil) {
                return _background!.height
            } else {
                return _label!.frame.size.height
            }
        }
        set {
            super.height = newValue
            if (_background != nil) { _background!.height = newValue }
            refreshSize()
        }
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
    public override func refreshSize(){
        
        let textContentW:CGFloat = _label!.intrinsicContentSize.width
        let textContentH:CGFloat = _label!.intrinsicContentSize.height
        
        let textPaddedContentW:CGFloat = textContentW + (_padding * 2)
        let textPaddedContentH:CGFloat = textContentH + (_padding * 2)
        
        func bgExpandCheck(){
            if (backgroundWidth < textPaddedContentW) {
                backgroundWidth = textPaddedContentW
            }
            if (backgroundHeight < textPaddedContentH) {
                backgroundHeight = textPaddedContentH
            }
        }
        
        //make sure label layout is correct after view has been resized
        
        //fit label view to text content
        
        if (_alignment == .left) {
            
            //adjust the label to fit the text
            //keep the xy as default
            _label!.frame = CGRect(
                x: _padding,
                y: _padding,
                width: textContentW,
                height: textContentH
            )
            
            
            if (_background != nil) {
                
                //expand the bg to fit if necessary
                bgExpandCheck()
            }
            
            
            
        } else if (_alignment == .center) {
            
            //adjust the label to fit the text
            //change x so label is centered at the XvText.x location
            _label!.frame = CGRect(
                x: -(textContentW / 2),
                y: _padding,
                width: textContentW,
                height: textContentH
            )
            
            if (_background != nil) {
                
                //expand the bg to fit if necessary
                bgExpandCheck()
                
                //center the bg rect around the centered text
                let extraBgW:CGFloat = _background!.width - textPaddedContentW
                _background!.x = -(textPaddedContentW / 2) - (extraBgW / 2)
            }
            
            
        } else if (_alignment == .right) {
            
            _label!.frame = CGRect(
                x: -(textContentW + _padding),
                y: _padding,
                width: textContentW,
                height: textContentH
            )
            
            if (_background != nil) {
                
                //expand the bg to fit if necessary
                bgExpandCheck()
                
                //center the bg rect around the centered text
                //let extraBgW:CGFloat = _background!.width - textPaddedContentW
                _background!.x = -_background!.width
            }
            
        }
        
    }
    
    public override func showBoundingBox(color:UIColor = UIColor.red){
        
        _label?.layer.borderColor = color.cgColor
        _label?.layer.borderWidth = 2.0
        
        //_background?.borderColor = UIColor.green
        //_background?.borderWidth = 2.0
                
    }
    
    
}
