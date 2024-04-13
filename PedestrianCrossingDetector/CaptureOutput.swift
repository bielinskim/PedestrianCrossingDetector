//
//  CaptureOutput.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import AVFoundation

extension CameraPreview {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let drawImage = detectObjects(sampleBuffer: sampleBuffer)
        
        DispatchQueue.main.async {
            self.previewView.image = drawImage
        }
    }
}
