//
//  XvStepper.swift
//  XvGui
//
//  Created by Jason Snell on 10/9/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

/*
 
 let stepper:XvStepper = XvStepper(
     target: self,
     action: #selector(stepperValueChanged(sender:)),
     minValue: minValue,
     maxValue: maxValue,
     startingValue: startingValue,
     stepValue: stepValue,
     wraps: wraps
 )
 
 @objc func stepperValueChanged(sender:UIStepper!){
     
    print(sender.value)

 }
 
 */

#if os(iOS)
import UIKit
#else
import AppKit
#endif

public class XvStepper:XvView {
    
    fileprivate let _stepper:UIStepper
    fileprivate let UISTEPPER_W:CGFloat = 94
    fileprivate let UISTEPPER_H:CGFloat = 27
    
    public init(
    
        //functionality
        target: Any,
        action:Selector,
        minValue:Double = 0.0,
        maxValue:Double = 1.0,
        startingValue:Double = 0.0,
        stepValue:Double = 0.1,
        wraps:Bool = false,
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0
        
    ){
        
        _stepper = UIStepper()
        _stepper.frame = CGRect(x:x, y:y, width: UISTEPPER_W, height: UISTEPPER_H)
        _stepper.maximumValue = maxValue
        _stepper.minimumValue = minValue
        _stepper.stepValue = stepValue
        
        //value must be set after max and min
        _stepper.value = startingValue
        
        _stepper.autorepeat = true
        _stepper.wraps = wraps
        
        _stepper.addTarget(target, action: action, for: .valueChanged)
        
        super.init(x: x, y: y, width: UISTEPPER_W, height: UISTEPPER_H)
        _view = _stepper as UIStepper
        
    }
    
    public var minValue:Double {
        get { return _stepper.minimumValue }
        set { _stepper.minimumValue = newValue }
    }
    
    public var maxValue:Double {
        get { return _stepper.maximumValue }
        set { _stepper.maximumValue = newValue }
    }
    
    public var value:Double {
        get { return _stepper.value }
        set { _stepper.value = newValue }
    }
    
    public var stepValue:Double {
        get { return _stepper.stepValue }
        set { _stepper.stepValue = newValue }
    }
    
    public var wraps:Bool {
        get { return _stepper.wraps }
        set { _stepper.wraps = newValue }
    }
}

