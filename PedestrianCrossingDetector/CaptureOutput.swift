//
//  CaptureOutput.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import AVFoundation

extension CameraPreview {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let detections = detectObjects(pixelBuffer: pixelBuffer)!
        
        let drawnImage = drawBoxes(detections, sampleBuffer, pixelBuffer)
        
        DispatchQueue.main.async {
            self.previewView.image = drawnImage
        }
    }
}
