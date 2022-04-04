//
//  IDRecognition.swift
//  PapilonIDRecognitioniOS
//
//  Created by Papilon Savunma on 4.03.2022.
//

import UIKit
import AVFoundation
import PapilonIDRecognitioniOS

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
//    id_type = {
//    0 :'TC_ID_FRONT',
//    1 :'TC_ID_BACK',
//    2 :'TC_OLD_ID_FRONT',
//    3 :'TC_OLD_ID_BACK',
//    4 :'TC_PASSPORT_FRONT',
//    5 :'TC_OLD_PASSPORT_FRONT',
//    6 :'TC_DRIVING_LICENCE_FRONT',
//    7 :'TC_DRIVING_LICENCE_BACK',
//    8 :'TC_OLD_DRIVING_LICENCE_FRONT',
//    9 :'TC_OLD_DRIVING_LICENCE_BACK',
//    10 :'AZ_ID_FRONT',
//    11 :'AZ_PASSPORT_FRONT',      
//    12 :'IRN_PASSPORT_FRONT',
//    13 :'PAK_NIC_ID_FRONT',
//    14 :'PAK_NIC_ID_BACK',
//    15 :'PAK_NICOP_ID_FRONT',
//    16 :'PAK_NICOP_ID_BACK'
//    }
    
    let idRecognizer = IDRecognizer(id_type: "", token: "", licence_id: "")
    private var scanningIsEnabled = true {
        didSet {
            scanningIsEnabled ? captureSession.startRunning() : captureSession.stopRunning()
        }
    }
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private var maskLayer = CAShapeLayer()
    
    private var isTapped = false
    
    override func viewDidAppear(_ animated: Bool) {
        //session Start
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //session Stopped
        self.videoDataOutput.setSampleBufferDelegate(nil, queue: nil)
        self.captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCameraInput()
        self.showCameraFeed()
        self.setCameraOutput()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.previewView.bounds

    }
    
    //MARK: Session initialisation and video output
    private func setCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .back).devices.first else {
                fatalError("No back camera device found.")
            }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func showCameraFeed() {
        self.previewLayer.videoGravity = .resizeAspectFill
        self.previewView.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.previewView.frame
    }
    
    private func setCameraOutput() {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
              connection.isVideoOrientationSupported else { return }
        
        connection.videoOrientation = .portrait
    }
    
    //MARK: AVCaptureVideo Delegate
    func captureOutput(_ output: AVCaptureOutput,didOutput sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        //      MARK: RUN THE LIB
        let resultDictionary = self.idRecognizer.detectIDCard(in: frame)
        if resultDictionary.isEmpty {
        }else  {
            self.captureSession.stopRunning()
            print(resultDictionary)
            DispatchQueue.main.sync {
                self.capturedImageView.image = idRecognizer.IDUIImage
            }
        }
    }
    
    
    func removeMask() {
        maskLayer.removeFromSuperlayer()
    }
    
    //MARK: Handle photo Button
    
    @IBAction func didTakePhoto(_ sender: UIButton) {
        self.isTapped = true
        //        self.captureSession.startRunning()
        
    }
}
