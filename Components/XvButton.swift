//
//  XvButton.swift
//  XvGui
//
//  Created by Jason Snell on 9/21/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

public class XvButton:XvView {
    
    fileprivate let _button:UIButton
    
    public init(
        
        //functionality
        target: Any,
        action:Selector,
        
        //location
        x:CGFloat,
        y:CGFloat,
        width:CGFloat,
        height:CGFloat,
        
        //text properties
        text:String = "",
        textColor:UIColor = .label,
        fontName:String = Text.HELV_NEUE,
        size:CGFloat = UIFont.systemFontSize,
        
        //background properties
        backgroundColor:UIColor = .secondarySystemBackground,
        borderColor:UIColor? = nil,
        borderWidth:CGFloat = 0,
        cornerRadius:CGFloat = 0
    ) {
        
        _button = UIButton(type: .system)
        
        //Mac OS
        //#selector(btnClick)
        //_button.addTarget(target, action:action, for: .touchUpInside)
        
        //iOS
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(
            target: target,
            action: action
        )
        
        _button.addGestureRecognizer(tap)
        _button.isUserInteractionEnabled = true
        
        _button.frame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
        
        _button.setTitle(text, for: .normal)
        _button.tintColor = .label //text color
        
        if let font:UIFont = UIFont(name: fontName, size: size){
        
            _button.titleLabel?.font = font
            
        } else {
            print("XvButton: Error: Unable to find font when creating input text")
        }
        
        _button.backgroundColor = backgroundColor
        _button.layer.borderWidth = borderWidth
        _button.layer.cornerRadius = cornerRadius
        
        //padding
        //_button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 30.0)
        
        super.init(x: x, y: y, width: width, height: height)
        _view = _button as UIView
        
        
    }
    
}
