//
//  CameraManager.swift
//  Tekk
//
//  Created by Jordan on 8/19/24.
//

import Foundation
import AVFoundation

class CameraManager: NSObject {
    // Performs real-time capture
    private let captureSession = AVCaptureSession()
    
    // Describes the media input from a capture device to a capture session
    private var deviceInput: AVCaptureDeviceInput?
    
    // Used to have access to video frames for processing
    private var videoOutput: AVCaptureVideoDataOutput?
    
    // Represents the hardware or virtual capture device that can provide one or more streams of media of a particular type
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    
    // the queue on which the AVCaptureVideoDataOutputSampleBufferDelegate callbacks should be invoked
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    // If the user has not granted permission to access the camera, we will request it here
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    // Allows us to manage the continuous stream of data provided
    private var addToPreviewStream: ((CGImage) -> Void)?
        lazy var previewStream: AsyncStream<CGImage> = {
            AsyncStream { continuation in
                addToPreviewStream = { cgImage in
                    continuation.yield(cgImage)
                }
            }
        }()
    
    // configure and start the AVCaptureSession at the same time
    override init() {
        super.init()
        
        Task {
            await configureSession()
            await startSession()
        }
    }
    
    // initializes all our properties and defines the buffer delegate
    private func configureSession() async {
        // Check user authorization, if the selected camera is available, and it can take the input through the AVCaptureDeviceInput object
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }
        
        // Start the configuration, marking the beginning of changes to the running capture session’s configuration
        captureSession.beginConfiguration()
        
        // At the end of the execution of the method commits the configuration to the running session
        defer {
            self.captureSession.commitConfiguration()
        }
        
        // Define the video output and set the Sample Buffer Delegate and the queue for invoking callbacks
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        // Check if the input can be added to the capture session
        guard captureSession.canAddInput(deviceInput) else {
            print("Unable to add device input to capture session.")
            return
        }
        
        // Checking if the output can be added to the session
        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }
        
        // Adds the input and the output to the AVCaptureSession
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
        // Set video orientation to portrait using the new API
        if let connection = videoOutput.connection(with: .video),
           connection.isVideoRotationAngleSupported(90) { // Check if 90 degrees is supported (portrait mode)
            connection.videoRotationAngle = 90 // Set 90 degrees for portrait mode
        }

    }
    
    // starts the camera session
    private func startSession() async {
        // Checking authorization
        guard await isAuthorized else { return }
        
        // Start the capture session flow of data
        captureSession.startRunning()
    }
}

// enables us to receive the various buffer frames from the camera.
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // called whenever the camera captures a new video frame.
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else { return }
        addToPreviewStream?(currentFrame)
    }
    
}
