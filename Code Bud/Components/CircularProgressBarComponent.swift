//
//  SwiftUIView.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 26/07/22.
//

import SwiftUI

struct CircularProgressBarComponent: View {
    @Binding var progress: Float
    @Binding var timeLeft: String
    @Binding var breakTimeLeft: String
    var mode: Mode
    
    enum Mode {
        case coding
        case onBreak
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.primaryColor)
            
            Circle()
                .trim(from: CGFloat(min(self.progress, 1.0)), to: 1.0)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.primaryColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            VStack {
                Text(timeLeft)
                    .font(.system(size: 50))
                    .bold()
                if mode == .coding {
                    Text("\(breakTimeLeft) to next break")
                }
            }
        }
    }
}
