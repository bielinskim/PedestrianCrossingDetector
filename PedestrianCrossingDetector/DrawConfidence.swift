//
//  DrawConfidence.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import SwiftUI
import Vision

extension CameraPreview {
    func drawConfidence(_ detection: VNRecognizedObjectObservation, _ cgContext: CGContext, _ box: CGRect, _ size: CGSize) {
        let text = "\(round(detection.confidence * 100))"

        let textRect  = CGRect(x: box.minX + size.width * 0.01, y: box.minY - size.width * 0.01, width: box.width, height: box.height)

        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: textRect.width * 0.1, weight: .bold),
            NSAttributedString.Key.foregroundColor: textColor,
        ]

        let attributedString = NSAttributedString(string: text, attributes: textFontAttributes)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let path = CGPath(rect: textRect, transform: nil)

        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(), path, nil)
        CTFrameDraw(frame, cgContext)
    }
}
