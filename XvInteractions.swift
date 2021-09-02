//
//  Interactions.swift
//  XvGui
//
//  Created by Jason Snell on 12/14/18.
//  Copyright © 2018 Jason Snell. All rights reserved.
//

import Foundation
import UIKit

public class XvInteractions {

    /*
     //example
     Interactions.addTap(
         view: view,
         target: self,
         action: #selector(tap(_:))
     )
     
     @objc func tap(_ gestureRecognizer: UIHoverGestureRecognizer) {
        print("tap", gestureRecognizer)
     }
     */
    
    public static func addTap(view:UIView, target:Any?, action:Selector?){
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(
            target: target,
            action: action
        )
        
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
 
    public static func addTouch(view:UIView, target:Any?, action:Selector?) {
        
        let touch:UILongPressGestureRecognizer = UILongPressGestureRecognizer(
            target: target,
            action: action
        )
        touch.minimumPressDuration = 0.1
        view.addGestureRecognizer(touch)
        view.isUserInteractionEnabled = true
    }
    
    /*
     //example
     Interactions.addHover(
         view: view,
         target: self,
         action: #selector(hover(_:))
     )
     
     @objc func hover(_ gestureRecognizer: UIHoverGestureRecognizer) {
         if (gestureRecognizer.state == .began) {
                 print("over", gestureRecognizer)
             } else if (gestureRecognizer.state == .ended) {
                 print("out", gestureRecognizer)
             }
         }
     } */
    
    public static func addHover(view:UIView, target:Any?, action:Selector?) {
        
        let hover:UIHoverGestureRecognizer = UIHoverGestureRecognizer(
            target: target,
            action: action
        )
        
        view.addGestureRecognizer(hover)
        view.isUserInteractionEnabled = true
    }
    
}

