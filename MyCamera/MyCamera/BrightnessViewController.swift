//
//  BrightnessViewController.swift
//  MyCamera
//
//  Created by Manish Kumar on 03/05/17.
//  Copyright © 2017 appface. All rights reserved.
//

import UIKit
import AVFoundation

class BrightnessViewController: UIViewController {
    var rateRange :AVFrameRateRange?
    @IBOutlet weak var thi: UISlider!
    @IBOutlet weak var sec: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        brightnessSlider.transform = CGAffineTransform(rotationAngle: (CGFloat(-Double.pi/2)))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func brightnessSliderAction(_ sender: UISlider) {
        
        sender.maximumValue = (device?.maxWhiteBalanceGain)! - 0.1
        do{
            if (device?.isWhiteBalanceModeSupported(.locked))!{
                try device?.lockForConfiguration()
                device?.whiteBalanceMode = .locked
                
                device?.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(AVCaptureWhiteBalanceGains.init(redGain: brightnessSlider.value , greenGain: sec.value , blueGain: thi.value), completionHandler: { (Time) in
                   device?.unlockForConfiguration()
                        print(device?.deviceWhiteBalanceGains ?? 1.0)
                                     })
                device?.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, iso: (device?.activeFormat.minISO)!, completionHandler: nil)
                

                
            }
        }catch{
            print("error")
          
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
    @IBAction func removeBrightnessSubviewAction(_ sender: UITapGestureRecognizer) {

    }

}
