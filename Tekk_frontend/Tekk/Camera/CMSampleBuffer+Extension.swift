//
//  CMSampleBuffer+Extension.swift
//  Tekk
//
//  Created by Jordan on 8/19/24.
//  This file contains the extension for CMSampleBuffer to convert it to CGImage.

import AVFoundation
import CoreImage

// Extend CMSampleBuffer to add a computed property for CGImage, needed for configureSession() in CameraManager
extension CMSampleBuffer {
    
    // Convert CMSampleBuffer to CGImage
    var cgImage: CGImage? {
        // Get the pixel buffer from the sample buffer
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(self)
        
        // Check if pixel buffer exists
        guard let imagePixelBuffer = pixelBuffer else {
            // Return nil if there is no pixel buffer
            return nil
        }
        
        // Convert pixel buffer to CIImage and then to CGImage
        return CIImage(cvPixelBuffer: imagePixelBuffer).cgImage
    }
    
}
