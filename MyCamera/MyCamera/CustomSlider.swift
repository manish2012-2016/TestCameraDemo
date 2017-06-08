//
//  CustomSlider.swift
//  MyCamera
//
//  Created by Manish Kumar on 27/04/17.
//  Copyright © 2017 appface. All rights reserved.
//

import UIKit
@IBDesignable
class CustomSlider: UISlider {
    
    @IBInspectable var rotationAngle : CGFloat = 0.0{
        didSet{
        getAngle()
        }
    
    }
    override func prepareForInterfaceBuilder() {
        getAngle()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func getAngle(){
    transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    

}
