//
//  MyCustomUIButton.swift
//  MyCamera
//
//  Created by Manish Kumar on 17/04/17.
//  Copyright © 2017 appface. All rights reserved.
//

import UIKit
@IBDesignable
class MyCustomUIButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 30.0{
    
        didSet{
           getCornerRadius()
        }
    
    }
    
    @IBInspectable var borderWidth : CGFloat = 20.0 {
        didSet{
         getBorderWidth()
        
        }
    
    }
    @IBInspectable var borderColor : UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1){
        didSet{
          getBorderColor()
        }
    
    }
    
    override func prepareForInterfaceBuilder() {
        getCornerRadius()
        getBorderWidth()
        getBorderColor()
    }

    
    func getCornerRadius(){
    layer.cornerRadius = cornerRadius
    }
    func getBorderWidth(){
       layer.borderWidth = borderWidth
    }
    func getBorderColor(){
    
    layer.borderColor = borderColor.cgColor
    }
}
