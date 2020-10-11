//
//  XvStepper.swift
//  XvGui
//
//  Created by Jason Snell on 10/9/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

public class XvStepper:XvView {
    
    fileprivate let _stepper:UIStepper
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
        y:CGFloat = 0,
        width:CGFloat = 100,
        height:CGFloat = 28
        
    ){
        
        _stepper = UIStepper()
        _stepper.frame = CGRect(x:x, y:y, width: width, height: height)
        _stepper.maximumValue = maxValue
        _stepper.minimumValue = minValue
        _stepper.stepValue = stepValue
        
        //value must be set after max and min
        _stepper.value = startingValue
        
        _stepper.autorepeat = true
        _stepper.wraps = wraps
        
        _stepper.addTarget(target, action: action, for: .valueChanged)
        
        super.init(x: x, y: y, width: width, height: height)
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

