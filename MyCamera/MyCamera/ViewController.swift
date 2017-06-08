//
//  ViewController.swift
//  MyCamera
//
//  Created by Manish Kumar on 12/04/17.
//  Copyright © 2017 appface. All rights reserved.
//

import UIKit
import Speech
import Darwin
enum CameraAction : String{
    case selfie = "ok", back = "back",contrast = "Manish", etc, none
}

protocol ConversionDelegate {
    func cameraAction(action: CameraAction, otherValue: Any?)
}
@available(iOS 10.0, *)
class ViewController: UIViewController,SFSpeechRecognizerDelegate {
    var delegate : ConversionDelegate?
    var matchingString : String?
    let speechRecognizer = SFSpeechRecognizer()
    
//    @IBOutlet weak var seconTextView: UITextView!
//    @IBOutlet weak var textViewForSpeech: UITextView!
//    
//    @IBOutlet weak var microPhone: UIButton!
    var action : CameraAction?
    var prevAction : CameraAction?
    var recoginationRequest:SFSpeechAudioBufferRecognitionRequest?
    var recoginationTask :SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    
    func tappedMicroPhone(_ sender: Any) {
        
        var isButtonEnable : Bool  = false
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized : isButtonEnable = true
            case .denied :
                isButtonEnable = false
            case .restricted :
                isButtonEnable = false
                print("Speech recognition is restricted")
            case .notDetermined :
                isButtonEnable = false
                print("Speech recognition is notDetermined")
                
            }
            OperationQueue.main.addOperation {
//                self.microPhone.isEnabled = isButtonEnable
            }
        }
        
        self.speechRecognizer?.delegate = self
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recoginationRequest?.endAudio()
//            microPhone.isEnabled = false
//            microPhone.setTitle("Start Recording", for: .normal)
            
        }else{
            startRecording()
//            microPhone.setTitle("Stop Recording", for: .normal)
        }
    }
    
    
    @available(iOS 10.0, *)
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool){
        
//        if available{
//            microPhone.isEnabled = true
//        }else{
//            microPhone.isEnabled =  false
//            
//        }
    }
    
    func startRecording(){
        if recoginationTask != nil{
            recoginationTask?.cancel()
            recoginationTask = nil
            
        }
        
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
        }catch{
            print("Audio session is not set")
        }
        
    
            recoginationRequest = SFSpeechAudioBufferRecognitionRequest()
       
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio input has no input")
        }
        
        guard let recoginationRequest = recoginationRequest else {
            fatalError("Unable to create recogination request")
        }
        
        recoginationRequest.shouldReportPartialResults = true
        recoginationTask = speechRecognizer?.recognitionTask(with: recoginationRequest, resultHandler: { (result, error) in
          //  var isFinal : Bool = false
            if result != nil{
                
//                self.textViewForSpeech.text = result?.bestTranscription.formattedString
                self.matchingString = result?.bestTranscription.formattedString
                print("Your convert voice to string is \(String(describing: result?.bestTranscription.formattedString))")
                
                
               // isFinal = (result?.isFinal)!
                
//                if error != nil || isFinal{
                    let speech = result?.bestTranscription.formattedString
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recoginationRequest = nil
                    self.recoginationTask = nil
                    if speech != nil{
                        self.takeActionForSpeech(speechText: speech!)
//                    }
//                    self.microPhone.isEnabled =  true
                }
            }
        })
        let recordinFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordinFormat) { (buffer, when) in
            self.recoginationRequest?.append(buffer)
        }
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        }catch{
            
            print("Audio engine can't start because of error")
        }
        

    }
    func takeActionForSpeech(speechText : String){
        refreshBuffer()
        if action == nil{
            for type in [CameraAction.selfie, CameraAction.contrast, CameraAction.etc]{
                if (speechText.localizedCaseInsensitiveContains(type.rawValue)){
                    action = type
                }
            }
            switch action ?? .none{
            case .selfie:
                
                if prevAction ?? .none == .selfie{
                    convertTextToSpeech(speechText: "Another selfie Choose yes or no")
                }else{
                    delegate?.cameraAction(action: .selfie, otherValue: nil)
                     
                    prevAction = action
                    
                    action = nil
                }
                
                break
            case .contrast:
                
                break
            default:
                break
            }
        }else{
            switch action! {
            case .selfie:
                
                if (speechText.localizedCaseInsensitiveContains("yes")){
                    print("taking selfie")
                    
                    self.delegate?.cameraAction(action: .selfie, otherValue: nil)
                    
                    prevAction = action
                    action = nil
                }else if(speechText.localizedCaseInsensitiveContains("no")){
                    print("ignoring selfie")
                    exit(0)
                    action = nil
                }
                break
            default:
                break
            }
        }
        
        
    }
    func refreshBuffer(){
        startRecording()
        
    }
    func convertTextToSpeech(speechText : String){
        
        print("asking to speak\(speechText)")
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: speechText)
        utterance.rate = 0.4
        //utterance.pitchMultiplier = 500
        synthesizer.speak(utterance)
        
        
    }
}

