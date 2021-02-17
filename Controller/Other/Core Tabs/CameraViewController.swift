//
//  CameraViewController.swift
//  Instagram
//
//  Created by Scott Colas on 1/5/21.
//

import UIKit
import AVFoundation
class CameraViewController: UIViewController {
    ///COULD USE SWIFTY CAM
    
    //capture session
    var captureSession = AVCaptureSession()
    
    
    // capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    //capture output
    var captureOutput = AVCaptureMovieFileOutput()
    
    //capture preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    
    private var previewLayer: AVPlayerLayer?
    
    var recordedViedoURL: URL? 
    
    //Scott Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        setUpCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        view.addSubview(recordButton)
        //navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(x: (view.width-size)/2, y: (view.height - view.safeAreaInsets.bottom - 5), width: size, height: size)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func didTapRecord(){
        if captureOutput.isRecording{
            //stop recording
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
            //HapticsManager.shared.vibrateForSelection()
        }else{
            guard var url = FileManager.default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask
            ).first else{
                return
            }
            
            url.appendPathComponent("video.mov")
            recordButton.toggle(for: .recording)
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    @objc private func didTapClose(){
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
        
    }
    func setUpCamera(){
        //add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio){
            //check if we can add camrea
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput){
                    captureSession.addInput(audioInput)
                }
            }

        }
        
        
       if let videoDevice = AVCaptureDevice.default(for: .video){
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice){
                if captureSession.canAddInput(videoInput){
                    captureSession.addInput(videoInput)
                }
            }
       }
        
        
        //uupdate session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput){
            //this is where are file is being writen to while we are recording
            captureSession.addOutput(captureOutput)
        }
        //configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        //enable cmaera start
        captureSession.startRunning()
    }
    private func didTapTakePicture(){
        
    }

}


extension CameraViewController: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else{
            let alert = UIAlertController(title: "Fuck!!",
                                          message: "Something went wrong tell Scott to fix this",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel,
                                          handler: nil))
            present(alert, animated: true)
            return
        }
        recordedViedoURL = outputFileURL
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "next",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapNext))
        print("Finished recording to url: \(outputFileURL.absoluteString)")
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else {
            return
        }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }
    
    @objc private func didTapNext(){
        // push caption controller
        guard let url  = recordedViedoURL else {
            return
        }
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
