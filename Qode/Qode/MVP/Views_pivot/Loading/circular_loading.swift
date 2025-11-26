//
//  circular_loading.swift
//  Qode
//
//  Created by Kwan Yeob Jung on 2025-11-11.
//

import SwiftUI
 
struct RingAnimation: View {
    @State private var drawingStroke = false
 
    let strawberry = Color.blue

 
    let animation = Animation
        .easeOut(duration: 3)
        .repeatForever(autoreverses: false)
        .delay(0.5)
 
    var body: some View {
        ZStack {
            Color.white
            ring(for: strawberry)
                .frame(width: 164)
        }
        .animation(animation, value: drawingStroke)
        .onAppear {
            drawingStroke.toggle()
        }
        .navigationBarBackButtonHidden(true)
    }
 
    func ring(for color: Color) -> some View {
        // Background ring
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 16))
            .foregroundStyle(.tertiary)
            .overlay {
                // Foreground ring
                Circle()
                    .trim(from: 0, to: drawingStroke ? 1 : 0)
                    .stroke(color.gradient,
                            style: StrokeStyle(lineWidth: 16, lineCap: .round))
            }
            .rotationEffect(.degrees(-90))
    }
}


#Preview {
    RingAnimation()
}
