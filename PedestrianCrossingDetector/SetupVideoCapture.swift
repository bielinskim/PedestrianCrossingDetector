//
//  SetupVideoCapture.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import AVFoundation

extension CameraPreview {
    func setupVideoCapture() {
        captureSession.beginConfiguration()
        
        let device = AVCaptureDevice.default(for: .video)
        let deviceInput = try! AVCaptureDeviceInput(device: device!)
        captureSession.addInput(deviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        let queue = DispatchQueue(label: "handlerQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(videoOutput)
        
        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
}
