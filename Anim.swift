//
//  AnimUtils.swift
//  Refraktions
//
//  Created by Jason Snell on 11/14/16.
//  Copyright © 2016 Jason J. Snell. All rights reserved.
//

import Foundation
import UIKit

public class Anim{
    
    fileprivate static let ANIM_SPEED:Double = 0.5
    
    //MARK: -
    //MARK: FADE IN
    public class func fadeIn(target:UIView){
        
        fadeIn(target:target, afterDelay:0)
        
    }
    
    public class func fadeIn(target:UIView, afterDelay:Double){
        
        fadeIn(target: target, afterDelay: afterDelay, toAlpha: 1.0)
        
    }
    
    public class func fadeIn(target:UIView, withDuration:Double){
        
        fadeIn(target: target, afterDelay: 0, toAlpha: 1.0, withDuration: withDuration)
        
    }
    
    public class func fadeIn(target:UIView, afterDelay:Double, withDuration:Double){
        
        fadeIn(target: target, afterDelay: afterDelay, toAlpha: 1.0, withDuration: withDuration)
        
    }
    
    public class func fadeIn(target:UIView, afterDelay:Double, toAlpha:CGFloat){
        
        fadeIn(target: target, afterDelay: afterDelay, toAlpha: toAlpha, withDuration: ANIM_SPEED)
        
    }
    
    fileprivate class func fadeIn(target:UIView, afterDelay:Double, toAlpha:CGFloat, withDuration:Double){
        
        UIView.animate(
            withDuration: withDuration,
            delay: afterDelay,
            options: UIView.AnimationOptions(),
            animations: {
                target.alpha = toAlpha
        },
            completion: nil)
    }
    
    //MARK: -
    //MARK: FADE OUT
    public class func fadeOut(target:UIView){
        
        fadeOut(target:target, afterDelay:0)
        
    }
    
    public class func fadeOut(target:UIView, withDuration:Double){
        
        fadeOut(target: target, toAlpha:0, afterDelay: 0, withDuration: withDuration)
    }
    
    public class func fadeOut(target:UIView, afterDelay:Double){
        
        fadeOut(target: target, toAlpha:0, afterDelay: afterDelay, withDuration: ANIM_SPEED)
    }
    
    public class func fadeOut(target:UIView, toAlpha:CGFloat){
        
        fadeOut(target: target, toAlpha: toAlpha, afterDelay: 0, withDuration: ANIM_SPEED)
    }
    
    fileprivate class func fadeOut(target:UIView, afterDelay:Double, withDuration:Double){
        
        fadeOut(target: target, toAlpha: 0, afterDelay: afterDelay, withDuration: withDuration)
    }
    
    public class func fadeOut(target:UIView, toAlpha:CGFloat, withDuration:Double){
        
        fadeOut(target: target, toAlpha:toAlpha, afterDelay: 0, withDuration: withDuration)
    }
    
    fileprivate class func fadeOut(target:UIView, toAlpha:CGFloat, afterDelay:Double, withDuration:Double){
        
        UIView.animate(
            withDuration: withDuration,
            delay: afterDelay,
            options: UIView.AnimationOptions(),
            animations: {
                target.alpha = toAlpha
        },
            completion: nil)
    }
    
    //MARK:-
    //MARK: REDRAW RECT
    public class func redraw(target:UIView, toRect:CGRect, afterDelay:Double){
        
        UIView.animate(
            withDuration: ANIM_SPEED,
            delay: 0.0,
            options: UIView.AnimationOptions(),
            animations: {
                target.frame = toRect
                
        },
            completion: nil)
    }
    
    //MARK:-
    //MARK: CHANGE COLOR
    public class func change(target:UIView, toColor:UIColor){
        
        change(target: target, toColor: toColor, withDuration: ANIM_SPEED)
        
    }
    
    public class func change(target:UIView, toColor:UIColor, withDuration:Double){
        
        UIView.animate(
            withDuration: withDuration,
            delay: 0.0,
            options: UIView.AnimationOptions(),
            animations: {
                target.backgroundColor = toColor
                
        },
            completion: nil)
    }
}

