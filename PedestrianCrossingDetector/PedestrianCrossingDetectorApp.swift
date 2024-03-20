//
//  PedestrianCrossingDetectorApp.swift
//  PedestrianCrossingDetector
//
//  Created by Mateusz Bieliński on 20/03/2024.
//

import SwiftUI

@main
struct PedestrianCrossingDetectorApp: App {
    var body: some Scene {
        WindowGroup {
            CameraPreviewAndDetectionsView()
        }
    }
}
