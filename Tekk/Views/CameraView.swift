//
//  CameraView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        ZStack {
            Color.green
        
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color.white)
                .font(.system(size: 100.0))
        }
    }
}

#Preview {
    CameraView()
}
