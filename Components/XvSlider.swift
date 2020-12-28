//
//  XvSlider.swift
//  XvGui
//
//  Created by Jason Snell on 10/7/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//example of action: #selector(self.sliderValueDidChange(sender:))

public class XvSlider:XvView {
    
    fileprivate let _slider:UISlider
    fileprivate let DEFAULT_HEIGHT:CGFloat = 25
    
    public init(
        
        //functionality
        target: Any,
        action:Selector,
        minValue:Float = 0,
        maxValue:Float = 1.0,
        startingValue:Float = 0,
        isContinous:Bool = true,
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        length:CGFloat = 300,
        
        //color
        barColor:UIColor? = nil,
        
        //anim
        anim:Bool = false
    
    ){
        
        //frame
        _slider = UISlider(frame:CGRect(x: x, y: y, width: length, height: DEFAULT_HEIGHT))
        
        //color
        if (barColor != nil) {
            _slider.tintColor = barColor!
        }
 
        //values
        _slider.minimumValue = minValue
        _slider.maximumValue = maxValue
        _slider.isContinuous = true
        
        //functionality
        _slider.addTarget(target, action: action, for: .valueChanged)
        _slider.isContinuous = isContinous
        
        super.init(x: x, y: y, width: length, height: DEFAULT_HEIGHT)
        _view = _slider as UISlider
        
        UIView.animate(withDuration: 0.8) {
            self._slider.setValue(startingValue, animated: anim)
        }
        
    }
    
    public var value:Float {
        get { return _slider.value }
        set { _slider.value = newValue }
    }
}

