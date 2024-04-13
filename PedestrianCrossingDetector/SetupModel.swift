//
//  SetupModel.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 13/04/2024.
//

import Vision

extension CameraPreview {
    func setupModel() {
        do {
            
            let model = try yolov8s().model
            let vnModel = try VNCoreMLModel(for: model)
            yoloRequest = VNCoreMLRequest(model: vnModel)
            
        } catch _ {
            fatalError("mlmodel error.")
        }
    }
}
