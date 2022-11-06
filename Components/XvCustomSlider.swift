//
//  XvSlider.swift
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

//example of action: #selector(self.sliderValueDidChange(sender:))

public class XvCustomSlider:UIViewController {
    
    
    //fileprivate let _slider:UISlider
    public func setup(
        
        //functionality
        target: Any,
        action:Selector,
        minValue:Float = 0,
        maxValue:Float = 1.0,
        startingValue:Float = 0,
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        
        handle:XvShape,
        well:XvRect
    
    
    ){
        
        
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        view.backgroundColor = .red
        //super.init(x: 400, y: 400, width: well.width, height: well.height)
        
        well.bgColor = .blue
        handle.bgColor = .green
        
        //add(shape: well)
        //add(shape: handle)
        
        
        
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longPressed(_:))
        )
        view.addGestureRecognizer(longPressRecognizer)
        
    }

    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer){
        print("longpressed")
    }
    
    
}

