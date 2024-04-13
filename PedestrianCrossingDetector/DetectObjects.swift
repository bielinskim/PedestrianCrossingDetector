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
    func detectObjects(pixelBuffer: CVPixelBuffer) -> [VNRecognizedObjectObservation]? {
        do {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try handler.perform([yoloRequest!])
            let results = yoloRequest!.results as! [VNRecognizedObjectObservation]
            

            return results
        } catch let error {
            print(error)
            
            return nil
        }
    }
}
