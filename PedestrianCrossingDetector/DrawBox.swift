//
//  DrawBox.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import SwiftUI
import AVFoundation
import Vision

extension CameraPreview {
    func drawBox(_ detection: Detection, _ cgContext: CGContext, _ size: CGSize) {
        let invertedBox = CGRect(x: detection.box.minX, y: size.height - detection.box.maxY, width: detection.box.width, height: detection.box.height)
        
        cgContext.textMatrix = .identity
        
        let text = "\(round(detection.confidence*100))"
        
        let textRect  = CGRect(x: invertedBox.minX + size.width * 0.01, y: invertedBox.minY - size.width * 0.01, width: invertedBox.width, height: invertedBox.height)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: textRect.width * 0.1, weight: .bold),
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        
        cgContext.saveGState()
        defer { cgContext.restoreGState() }
        
        let astr = NSAttributedString(string: text, attributes: textFontAttributes)
        let setter = CTFramesetterCreateWithAttributedString(astr)
        let path = CGPath(rect: textRect, transform: nil)
        
        let frame = CTFramesetterCreateFrame(setter, CFRange(), path, nil)
        cgContext.textMatrix = CGAffineTransform.identity
        CTFrameDraw(frame, cgContext)
        
        cgContext.setStrokeColor(color.cgColor)
        cgContext.setLineWidth(9)
        cgContext.stroke(invertedBox)
    }
}
