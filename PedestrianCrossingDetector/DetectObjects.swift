//
//  DetectObjects.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import SwiftUI
import AVFoundation
import Vision

extension CameraPreview {
    func detectObjects(sampleBuffer: CMSampleBuffer) -> UIImage? {
        do {
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try handler.perform([yoloRequest!])
            
            let results = yoloRequest!.results as! [VNRecognizedObjectObservation]
            
            let detections: [Detection] = results.map { result in
                let boundingBox = result.boundingBox
                let rotatedBox = CGRect(x: boundingBox.minX, y: 1 - boundingBox.maxY, width: boundingBox.width, height: boundingBox.height)
                
                let dimensions = sampleBuffer.formatDescription!.dimensions
                let box = VNImageRectForNormalizedRect(rotatedBox, Int(dimensions.width), Int(dimensions.height))
                
                let detection = Detection(box: box, confidence: result.confidence)
                
                return detection
            }
            
            let drawImage = drawBoxes(detections, pixelBuffer)
            
            return drawImage
        } catch let error {
            print(error)
            
            return nil
        }
    }
}

