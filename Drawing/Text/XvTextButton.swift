//
//  XvTextButton.swift
//  XvGui
//
//  Created by Jason Snell on 8/17/22.
//  Copyright © 2022 Jason Snell. All rights reserved.
//

import UIKit

public class XvTextButton:XvText{
    
    public var hitZone:XvRect
    
    //init with standard values
    public init(
        
        //location
        x:CGFloat = 0,
        y:CGFloat = 0,
        width:CGFloat = 0,
        height:CGFloat = 0,
        
        //text properties
        text:String = "",
        color:UIColor = .white,
        fontName:String = Text.HELV_NEUE,
        size:CGFloat = UIFont.systemFontSize,
        
        //background properties
        backgroundColor:UIColor? = nil,
        backgroundWidth:CGFloat? = nil,
        borderColor:UIColor? = nil,
        borderWidth:CGFloat = 0,
        cornerRadius:CGFloat = 0,
        padding:CGFloat = 0) {
        
            //make the hit zone
            hitZone = XvRect(x: 0, y: 0, width: width, height: height, bgColor: .red)
            
            //pass up to XvText
            //note: alignment is always .left
            super.init(x: x, y: y, width: width, height: height, text: text, color: color, fontName: fontName, size: size, alignment: .left, backgroundColor: backgroundColor, backgroundWidth: backgroundWidth, borderColor: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius, padding: padding)
            
            //show for testing, comment out for deploy
            //hitZone.alpha = 0.5
          
            //add on top of the XvText graphics
            view.addSubview(hitZone.view)
        
    }
    
    public override func addTap(delegate:XvViewTapDelegate){
        hitZone.addTap(delegate: delegate)
    }
    
    //MARK: Resizing
    public override func refreshSize(){
        
        let textContentW:CGFloat = label!.intrinsicContentSize.width
        let textContentH:CGFloat = label!.intrinsicContentSize.height
        
        let textPaddedContentW:CGFloat = textContentW + (padding * 2)
        let textPaddedContentH:CGFloat = textContentH + (padding * 2)
        
        func bgExpandCheck(){
            if (backgroundWidth < textPaddedContentW) {
                backgroundWidth = textPaddedContentW
            }
            if (backgroundHeight < textPaddedContentH) {
                backgroundHeight = textPaddedContentH
            }
        }
        
        //adjust the label to fit the text
        //keep the xy as default
        label!.frame = CGRect(
            x: (width/2)-(textContentW/2),
            y: padding,
            width: textContentW,
            height: textContentH
        )
        
        //expand the bg to fit if necessary
        bgExpandCheck()
        
    }
}
