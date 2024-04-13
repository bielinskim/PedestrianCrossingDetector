//
//  CameraAndDetectionsView.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 20/03/2024.
//

import SwiftUI

struct CameraPreviewAndDetectionsView: View {
    
    var body: some View {
        CameraPreviewControllerWrapper()
    }
}

struct CameraPreviewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraPreview {
        return CameraPreview()
    }
    
    func updateUIViewController(_ uiViewController: CameraPreview, context: Context) {
        
    }
}
