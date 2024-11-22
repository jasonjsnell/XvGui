//
//  XvSegmentedControl.swift
//  XvGui
//
//  Created by Jason Snell on 10/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

//example of action: #selector(segmentedValueChanged(sender:))

@available(iOS 13.0, *)
public class XvSegmentedControl:XvView {
    
    fileprivate let _segmentedControl:UISegmentedControl
    
    public init(
        
        //functionality
        target: Any,
        action:Selector,
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        width:CGFloat,
        height:CGFloat,
        
        //text properties
        items:[String],
        textColor:UIColor = .label,
        fontName:String = Text.HELV_NEUE,
        size:CGFloat = UIFont.systemFontSize,
        
        //background properties
        backgroundColor:UIColor = .secondarySystemBackground,
        borderColor:UIColor? = nil,
        borderWidth:CGFloat = 0
    ){
        
        //frame
        _segmentedControl = UISegmentedControl (items: items)
        _segmentedControl.frame = CGRect(x: x, y: y, width: width, height: height)

        //background
        _segmentedControl.backgroundColor = backgroundColor
        _segmentedControl.layer.borderWidth = borderWidth
        _segmentedControl.layer.borderColor = borderColor?.cgColor
            
        //text
        if let font:UIFont = UIFont(name: fontName, size: size){
        
            let textAttr: [NSAttributedString.Key : AnyObject] = [
                NSAttributedString.Key.foregroundColor : textColor,
                NSAttributedString.Key.font : font
            ]
            
            _segmentedControl.setTitleTextAttributes(textAttr, for:.normal)
            _segmentedControl.setTitleTextAttributes(textAttr, for:.highlighted)
            _segmentedControl.setTitleTextAttributes(textAttr, for:.selected)
            
        } else {
            print("XvSegmentedControl: Error: Unable to find font when creating input text")
        }
    
        // make first segment selected
        _segmentedControl.selectedSegmentIndex = 0
                
        // add target and action
        _segmentedControl.addTarget(target, action: action, for: .valueChanged)
                
        super.init(x: x, y: y, width: width, height: height)
        _view = _segmentedControl as UISegmentedControl
    }
    
    public func select(segment:Int) {
        _segmentedControl.selectedSegmentIndex = segment
    }
}
