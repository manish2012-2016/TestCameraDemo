//
//  CameraViewController.swift
//  MyCamera
//
//  Created by Manish Kumar on 13/04/17.
//  Copyright © 2017 appface. All rights reserved.
//

import UIKit
import AVFoundation
@available(iOS 10.0, *)
class CameraViewController: UIViewController {

    @IBOutlet weak var navigationLabel: UINavigationBar!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var buttonOutlet: MyCustomUIButton!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCapturePhotoOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
