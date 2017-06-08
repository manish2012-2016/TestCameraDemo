//
//  LensAdjustViewController.swift
//  MyCamera
//
//  Created by Manish Kumar on 05/05/17.
//  Copyright © 2017 appface. All rights reserved.
//

import UIKit
import AVFoundation
class LensAdjustViewController: UIViewController {

    
    @IBOutlet weak var lensAdjustSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func lensAdjustAction(_ sender: UISlider) {
        if (device?.isFocusModeSupported(.autoFocus))!{
        do{
        try device?.lockForConfiguration()
     //func setFocusModeLockedWithLensPosition(_ lensPosition: Float, completionHandler handler: ((CMTime) -> Swift.Void)!)
        device?.setFocusModeLockedWithLensPosition(lensAdjustSlider.value, completionHandler: { (Time) in
            
        })
            device?.unlockForConfiguration()
        }catch{
         print("Error")
        }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
