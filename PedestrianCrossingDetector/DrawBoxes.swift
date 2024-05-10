//
//  DrawBoxes.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import SwiftUI
import AVFoundation
import Vision

extension CameraPreview {
    func drawBoxes(_ detections: [VNRecognizedObjectObservation], _ sampleBuffer: CMSampleBuffer, _ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        
        let cgContext = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 4 * Int(size.width),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        for detection in detections {
            let boundingBox = detection.boundingBox
            let dimensions = sampleBuffer.formatDescription!.dimensions
            let box = VNImageRectForNormalizedRect(boundingBox, Int(dimensions.width), Int(dimensions.height))
            
            if (detection.confidence >= 0.8) {
                drawBox(detection, cgContext, box)
                drawConfidence(detection, cgContext, box, size)
            }
        }
        
        let newImage = cgContext.makeImage()!
        
        return UIImage(ciImage: CIImage(cgImage: newImage))
    }
}
