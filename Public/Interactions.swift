//
//  Interactions.swift
//  XvGui
//
//  Created by Jason Snell on 12/14/18.
//  Copyright © 2018 Jason Snell. All rights reserved.
//

import Foundation
import UIKit

public class Interactions {

    
    public static func addTap(view:UIView, target:Any?, action:Selector?){
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(
            target: target,
            action: action
        )
        
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
    }
    
}
