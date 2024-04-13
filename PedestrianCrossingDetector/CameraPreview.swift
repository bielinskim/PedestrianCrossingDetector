//
//  CameraPreview.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import SwiftUI
import AVFoundation
import Vision

class CameraPreview: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var previewView = UIImageView(frame: UIScreen.main.bounds)
    var captureSession = AVCaptureSession()
    var yoloRequest: VNRequest?
    let color = UIColor(red: 0.30, green: 0.96, blue: 0.08, alpha: 1.0)
    let textColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
    let ciContext = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(previewView)
        
        setupModel()
        
        setupVideoCapture()
        
    }
}
