//
//  XvImage.swift
//  XvGui
//
//  Created by Jason Snell on 9/18/20.
//  Copyright © 2020 Jason Snell. All rights reserved.
//

import UIKit

//MARK: - XV IMAGE

open class XvImage:XvShape {
    
    fileprivate var _image:UIImageView?
    
    public init(
        x:CGFloat,
        y:CGFloat,
        imageName:String
    ){
        
        super.init(x: x, y: y, width: 0, height: 0)
        
        //if name leads to valid asset
        if let image:UIImage = UIImage(named: imageName){
            
            //make the image
            _image = UIImageView(image: image)
            
            //add to shape
            _view.addSubview(_image!)
            
            //set parent frame to the size of the image
            super.width = _image!.frame.width
            super.height = _image!.frame.height
            
        } else {
            print("XvImage: Error: Image name", imageName, "invalid")
        }
    }
    
    //MARK: Frame
    public var image:UIImageView? {
        get { return _image }
    }
    
    public override var width:CGFloat {
        get { return super.width }
        set {
            _image?.frame.size.width = newValue //resize image
            super.width = newValue //resize parent UIView
        }
    }
    
    public override var height:CGFloat {
        get { return super.height }
        set {
            _image?.frame.size.height = newValue //resize image
            super.height = newValue //resize parent UIView
        }
    }
    
    public override func refreshSize(){
        
        _image?.layer.frame.size.width = _view.frame.size.width
        _image?.layer.frame.size.height = _view.frame.size.height
        
        super.refreshSize()
        
    }
}
