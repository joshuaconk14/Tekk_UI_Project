//
//  ViewB.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import SwiftUI

struct ViewB: View {
    var body: some View {
        ZStack {
            Color.purple
        
            Image(systemName: "person.2.fill")
                .foregroundColor(Color.white)
                .font(.system(size: 100.0))
        }    }
}

#Preview {
    ViewB()
}
