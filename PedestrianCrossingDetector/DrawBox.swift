//
//  DrawBox.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import SwiftUI
import Vision

extension CameraPreview {
    func drawBox(_ detection: VNRecognizedObjectObservation, _ cgContext: CGContext, _ box: CGRect) {
        cgContext.setStrokeColor(color.cgColor)
        cgContext.setLineWidth(9)
        cgContext.stroke(box)
    }
}
