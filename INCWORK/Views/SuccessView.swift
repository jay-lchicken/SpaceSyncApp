//
//  SuccessView.swift
//  INCINCINC
//
//  Created by Lai Hong Yu on 10/8/24.
//
// THIS ANIMATION IS MADE FROM CHATGPT AS WE HAVE NO CREATIVITY
import SwiftUI

struct TickAnimation: View {
    @State private var drawTick: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.green)
                            .opacity(drawTick ? 1 : 0)
                            .animation(Animation.easeInOut(duration: 0.8))
            TickShape()
                .trim(from: 0, to: drawTick ? 1 : 0)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.green)
                .animation(Animation.easeInOut(duration: 0.8))
                .onAppear {
                    self.drawTick.toggle()
                }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct TickShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.size.width * 0.25, y: rect.size.height * 0.5))
        path.addLine(to: CGPoint(x: rect.size.width * 0.45, y: rect.size.height * 0.7))
        path.addLine(to: CGPoint(x: rect.size.width * 0.75, y: rect.size.height * 0.3))
        
        return path
    }
}
struct SuccessView: View {

    
    var body: some View {
        
        
        TickAnimation()
            .frame(maxWidth: 250, maxHeight: 250)
        
        Text("Success")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.green)
            .padding(.top, 40)
        
        
    }
}

