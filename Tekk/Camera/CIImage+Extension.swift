//
//  CIImage+Extension.swift
//  Tekk
//
//  Created by Jordan on 8/19/24.
//

import CoreImage

// Extend CIImage to add a computed property for CGImage
extension CIImage {
    
    // Convert CIImage to CGImage
    var cgImage: CGImage? {
        // Create a CIContext to render the CIImage
        let ciContext = CIContext()
        
        // Convert CIImage to CGImage using the CIContext
        // The `from` parameter specifies the region of the CIImage to render
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {
            // Return nil if the conversion fails
            return nil
        }
        
        // Return the converted CGImage
        return cgImage
    }
    
}
