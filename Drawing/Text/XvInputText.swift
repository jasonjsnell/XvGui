//
//  XvInputText.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

//MARK: - Input Text -

public protocol XvInputTextDelegate:AnyObject {
    
    func editingDidBegin(textField:UITextField)
    func editingChanged(textField:UITextField)
    func editingDidEnd(textField:UITextField)
    func selectDidBegin(textField:UITextField)
    //func editingDidEndOnExit(textField:UITextField)
}


public class XvInputText:XvView {
    
    fileprivate let _textField:UITextField
   
    public weak var delegate:XvInputTextDelegate?
    
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
        //maxLines:Int = 0, //0 = no limit, 1 = 1 lines, 2 = 2 lines, etc
        
        //background properties
        backgroundColor:UIColor? = nil,
        borderColor:UIColor? = nil,
        borderWidth:CGFloat = 2.0,
        cornerRadius:CGFloat = 8.0
    ){
        
        //init object
            
        _textField = UITextField(frame: CGRect(
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
        //_textField.textContainer.maximumNumberOfLines = maxLines
        if (backgroundColor != nil) { _textField.backgroundColor = backgroundColor }
        if (borderColor != nil) { _textField.layer.borderColor = borderColor?.cgColor }
        _textField.layer.borderWidth = borderWidth
        _textField.layer.cornerRadius = cornerRadius
        
        //defaults
        _textField.tintColor = .blue
        
        
        //_textField.layer.masksToBounds = true;
        //_textField.autocorrectionType = UITextAutocorrectionType.no
        //_textField.keyboardType = UIKeyboardType.default
        //_textField.returnKeyType = UIReturnKeyType.done
    
        _textField.text = text
            
        super.init(x: x, y: y, width: width, height: height)
            
        //add listeners
        //select field
        _textField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        
        //typing
        _textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        //hit enter
        _textField.addTarget(self, action: #selector(editingDidEnd(_:)), for: .editingDidEnd)
        
        _textField.addTarget(self, action: #selector(selectDidBegin(_:)), for: .touchDown)
        
        //_textField.addTarget(self, action: #selector(editingDidEndOnExit(_:)), for: .editingDidEndOnExit)

         
        _view = _textField as UIView
    }
    
    
    @objc private func editingDidBegin(_ textField: UITextField) {
        delegate?.editingDidBegin(textField: textField)
    }
    @objc private func editingChanged(_ textField: UITextField) {
        delegate?.editingChanged(textField: textField)
    }
    
    @objc private func editingDidEnd(_ textField: UITextField) {
        delegate?.editingDidEnd(textField: textField)
    }
    
    @objc private func selectDidBegin(_ textField: UITextField) {
        delegate?.selectDidBegin(textField: textField)
    }
    
//    @objc private func editingDidEndOnExit(_ textField: UITextField) {
//        delegate?.editingDidEndOnExit(textField: textField)
//    }
    
    public var text:String? {
        get { return _textField.text }
        set { _textField.text = newValue }
    }
    
    public func restrictToNumbersOnly(){
        _textField.keyboardType = .asciiCapableNumberPad
    }
   
    
}
