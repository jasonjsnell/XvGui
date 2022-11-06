//
//  XvSwitch.swift
//  XvGui
//
//  Created by Jason Snell on 11/14/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

/*
 
 let switch:XvSwitch = XvSwitch(
     target: self,
     action: #selector(toggled),
     defaultValue: tempOnBool
 )
 
 @objc func toggled(sender:UISwitch!){
     
    print(sender.value)
 }
 
 */

#if os(iOS)
import UIKit
#else
import AppKit
#endif

public class XvSwitch:XvView {
    
    fileprivate let _switch:UISwitch
    fileprivate let UISWITCH_W:CGFloat = 51
    fileprivate let UISWITCH_H:CGFloat = 31
    
    public init(
    
        //functionality
        target: Any,
        action:Selector,
        defaultValue:Bool,
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0
        
    ){
        
        _switch = UISwitch()
        _switch.frame = CGRect(x:x, y:y, width: UISWITCH_W, height: UISWITCH_H)
        _switch.isOn = defaultValue
        _switch.setOn(defaultValue, animated: false)
        
        _switch.addTarget(target, action: action, for: .valueChanged)
        
        super.init(x: x, y: y, width: UISWITCH_W, height: UISWITCH_H)
        _view = _switch as UISwitch
        
    }
   
    public var isOn:Bool {
        get { return _switch.isOn }
        set { _switch.isOn = newValue }
    }

}

