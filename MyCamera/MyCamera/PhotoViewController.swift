//
//  PhotoViewController.swift
//  MyCamera
//
//  Created by Manish Kumar on 13/04/17.
//  Copyright © 2017 appface. All rights reserved.2
//

import UIKit
import AVFoundation
@available(iOS 10.0, *)
var device : AVCaptureDevice?
class PhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate,ConversionDelegate {
    //@IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet var panGestureOutlet: UIPanGestureRecognizer!
    let brightnessVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brightnessID") as! BrightnessViewController
    let lensAdjustmentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LensAdjustViewController") as! LensAdjustViewController
    
    @IBOutlet weak var sliderOutlet: UISlider!
    var toggleBool : Bool = false
    let minimumZoom: CGFloat = 1.0
    var maximumZoom: CGFloat = 5.0
    var lastZoomFactor: CGFloat = 1.0
    
    var captureSession : AVCaptureDeviceDiscoverySession!
    var needToShowFrontCamera : Bool = true
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!
    // var myImage = [#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "6"),#imageLiteral(resourceName: "7")]
    var session = AVCaptureSession()
    var timer : Timer?
    
    var captureOutputSession  = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var setting = AVCapturePhotoSettings()
    var viewController = ViewController()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        viewController.delegate = self
        viewController.startRecording()
        brightnessVC.view.frame = CGRect(x: 0, y: 70, width: 450, height: 350)
        self.addChildViewController(brightnessVC)
        view.addSubview(brightnessVC.view)
        brightnessVC.didMove(toParentViewController: self)
        //panGestureOutlet.isEnabled = false
        
        brightnessVC.view.isHidden = true
        lensAdjustmentVC.view.frame = CGRect(x: 0, y: 75, width: self.view.frame.width, height: 31)
        
        self.addChildViewController(lensAdjustmentVC)
        view.addSubview(lensAdjustmentVC.view)
        lensAdjustmentVC.didMove(toParentViewController: self)
        lensAdjustmentVC.view.isHidden = true
        lensAdjustmentVC.view.backgroundColor = UIColor.clear
        
        // brightnessVC.view.bounds = true
        
        //       imageView.animationImages = myImage
        //      imageView.animationDuration = 0.75
        // Do any additional setup after loading the view.
    }
    func cameraAction(action: CameraAction, otherValue: Any?) {
        switch action {
        case .selfie:
            timer = Timer(timeInterval: 1.0, target: self, selector: #selector(showTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
            count = 1
            let deadlineTime = DispatchTime.now() + .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.timer?.invalidate()
                self.didTakePhoto(self)
                
                
            }
            
            break
        default:
            break
        }
    }
    func showTimer(){
        print("timer count \(count)")
        
        count -= 1
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initialiseCamera()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.position = CGPoint(x: self.previewView.frame.width/2, y: self.previewView.frame.height/2)
        previewLayer.bounds = previewView.frame
        print(previewLayer.metadataOutputRectOfInterest(for: previewLayer.frame))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTakePhoto(_ sender: Any) {
        captureOutputSession.capturePhoto(with: AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecJPEG]), delegate: self)
        
    }
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        print(error ?? "error is nil")
        if error == nil{
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage.init(data: photoData!)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            captureImageView.image = image
            
        }
        
        
    }
    
    @IBAction func changeCameraViewAction(_ sender: Any) {
        
        needToShowFrontCamera = !needToShowFrontCamera
        initialiseCamera()
        
        
    }
    func initialiseCamera(){
        sliderOutlet.value = sliderOutlet.minimumValue
        captureSession =  AVCaptureDeviceDiscoverySession.init(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        for loopDevice in (captureSession?.devices)!{
            if (loopDevice.position == .front && needToShowFrontCamera){
                device = loopDevice
            }else if (loopDevice.position == .back && !needToShowFrontCamera){
                device = loopDevice
            }
        }
        if previewView.layer.sublayers != nil{
            for layer in previewView.layer.sublayers!{
                layer.removeFromSuperlayer()
            }
        }
        
        if device != nil{
            do {
                
                let input = try AVCaptureDeviceInput(device: device!)
                session.stopRunning()
                if session.outputs.count > 0{
                    session.removeOutput(session.outputs.first as! AVCaptureOutput)
                }
                session = AVCaptureSession()
                session.sessionPreset = AVCaptureSessionPresetPhoto
                
                captureOutputSession  = AVCapturePhotoOutput()
                
                if session.canAddInput(input){
                    
                    session.addInput(input)
                    if session.canAddOutput(captureOutputSession){
                        session.startRunning()
                        session.addOutput(captureOutputSession)
                        previewLayer = AVCaptureVideoPreviewLayer(session: session)
                        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
                        previewLayer.connection.videoOrientation =  AVCaptureVideoOrientation.portrait
                        previewView.layer.addSublayer(previewLayer)
                        previewLayer.position = CGPoint(x: self.previewView.frame.width/2, y: self.previewView.frame.height/2)
                        previewLayer.bounds = previewView.frame
                    }
                }
            } catch{
                
                print("Error")
            }
            
            
            
        }
    }
    
    
    @IBAction func zoomImageAction(_ pinch: UIPinchGestureRecognizer) {
        brightnessVC.view.isHidden  = true
        if session.inputs.count > 0{
            //            sliderOutlet.maximumValue = Float(device?.activeFormat.videoMaxZoomFactor ?? 0)
            //            maximumZoom = CGFloat(sliderOutlet.maximumValue)
            
            let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
            
            switch pinch.state {
            case .began: fallthrough
            case .changed: update(scale: newScaleFactor)
            case .ended:
                lastZoomFactor = minMaxZoom(newScaleFactor)
                update(scale: lastZoomFactor)
            default: break
            }
            sliderOutlet.value = Float(newScaleFactor)
        }
    }
    
    @IBAction func slider(_ sender: UISlider) {
        brightnessVC.view.isHidden  = true
        if session.inputs.count > 0{
            update(scale: minMaxZoom(CGFloat(sender.value)))
            brightnessVC.view.isHidden  = true
        }
    }
    @IBAction func primeryActionForSlider(_ sender: Any) {
        //        if session.inputs.count > 0{
        //            sliderOutlet.maximumValue = Float(device?.activeFormat.videoMaxZoomFactor ?? 0)
        //            maximumZoom = CGFloat(sliderOutlet.maximumValue)
        //        }
    }
    
    func minMaxZoom(_ factor: CGFloat) -> CGFloat {
        return min(min(max(factor, minimumZoom), maximumZoom), device!.activeFormat.videoMaxZoomFactor)
    }
    
    func update(scale factor: CGFloat) {
        do {
            try device?.lockForConfiguration()
            defer { device?.unlockForConfiguration() }
            device?.videoZoomFactor = factor
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    
    @IBAction func sliderBrightnessAction(_ sender: UISlider) {
        //        var incandescentLightCompensation = 3_000
        //        var tint = 0 // no shift
        //        let temperatureAndTintValues = AVCaptureWhiteBalanceTemperatureAndTintValues(temperature: Float(incandescentLightCompensation), tint: Float(tint))
        //        var deviceGains = currentCameraDevice.deviceWhiteBalanceGainsForTemperatureAndTintValues(temperatureAndTintValues)
        //            //... // lock for configuration
        //            currentCameraDevice.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(deviceGains) {
        //                (timestamp:CMTime) -> Void in
        //        }
        //
    }
    
    
    @IBAction func removeActionBrightnessSlider(_ sender: UITapGestureRecognizer) {
        
        brightnessVC.view.isHidden  = true
    }
    
    @IBAction func panGestureAction(_ sender: UIPanGestureRecognizer) {
        brightnessVC.view.isHidden = false
    }
    
    @IBAction func toggleLensAction(_ sender: UIBarButtonItem) {
        
        brightnessVC.view.isHidden = false

        if toggleBool{
            lensAdjustmentVC.view.isHidden = false
            toggleBool = !toggleBool
        }else{
            lensAdjustmentVC.view.isHidden = true
            toggleBool = !toggleBool
        }
        
}
    
}
