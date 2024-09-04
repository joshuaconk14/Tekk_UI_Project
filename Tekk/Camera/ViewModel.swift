//
//  ViewModel.swift
//  Tekk
//
//  Created by Jordan on 8/19/24.
//  This file contains the ViewModel, which is used to manage the camera feed.

import Foundation
import CoreImage
import Observation

@Observable
class ViewModel {
    var currentFrame: CGImage?
    private let cameraManager = CameraManager()
    
    // call the handleCameraPreviews() method when initializing the ViewModel object
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    // handles the updates of the AsyncStream and move the update of the published variables to the MainActor, updating the UI.
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                currentFrame = image
            }
        }
    }
}
