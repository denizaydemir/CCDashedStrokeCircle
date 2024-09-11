//
//  Test2.swift
//  Blindstory
//
//  Created by Deniz Aydemir on 10.09.2024.
//  Copyright © 2024 Deniz Aydemir. All rights reserved.
//

import SwiftUI

struct CCDashedStrokeCircle: View {
    let strokeCount: Int
    let gapDegrees: Double = 6  // Customize the gap between segments
    let customColors: [Int: Color]
    
    var body: some View {
        ZStack {
            ForEach(0..<strokeCount, id: \.self) { index in
                SegmentView(strokeCount: strokeCount, gapDegrees: gapDegrees)
                
                    .stroke(style: StrokeStyle(lineWidth: 3.34, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(Double(index) * (360.0 / Double(strokeCount))))
                    .foregroundStyle(colorForSegment(index: index))
                
            }
            
//            ZStack {
//                Spacer()
//                    .frame(minWidth: 1, maxWidth: 1, minHeight: 0, maxHeight: .infinity)
//                    .background(Color.red)
//                
//                Spacer()
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
//                    .background(Color.red)
//            }        
//            .rotationEffect(.degrees(-3))


        }
        .rotationEffect(.degrees(273))
        .frame(width: 100, height: 100)
    }
    

    
    func colorForSegment(index: Int) -> Color {
        // Check if a custom color is provided
        if let customColor = customColors[index] {
            return customColor
        } else {
            // Calculate gradient color dynamically
            let colorProgress = Double(index) / Double(strokeCount - 1)
            
            // Intermediate color calculation
            return Color(UIColor.interpolateColors(firstColor: UIColor(CustomColor.testGradient1),
                    secondColor: UIColor(CustomColor.testGradient2),
                    thirdColor: UIColor(CustomColor.testGradient3),
                    fourthColor: UIColor(CustomColor.testGradient4),
                    progress: CGFloat(colorProgress)))
        }
    }
    
}

struct SegmentView: Shape {
    var strokeCount: Int
    var gapDegrees: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.width / 2
        let totalGap = gapDegrees * Double(strokeCount)  // Total gap degrees in the circle
        let segmentDegrees = (360.0 - totalGap) / Double(strokeCount)
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(segmentDegrees),
                    clockwise: false)
        return path
    }
}

extension UIColor {
    static func interpolateColors(firstColor: UIColor, secondColor: UIColor, thirdColor: UIColor, fourthColor: UIColor, progress: CGFloat) -> UIColor {
        // Determine which third of the gradient to use
        let (startColor, endColor, localProgress) = progress < 0.33 ?
            (firstColor, secondColor, progress * 3) :
            progress < 0.66 ?
            (secondColor, thirdColor, (progress - 0.33) * 3) :
            (thirdColor, fourthColor, (progress - 0.66) * 3)

        return interpolateColorTo(start: startColor, end: endColor, progress: localProgress)
    }

    static func interpolateColorTo(start: UIColor, end: UIColor, progress: CGFloat) -> UIColor {
        let startComponents = start.cgColor.components ?? [0, 0, 0, 0]
        let endComponents = end.cgColor.components ?? [0, 0, 0, 0]

        let red = startComponents[0] + (endComponents[0] - startComponents[0]) * progress
        let green = startComponents[1] + (endComponents[1] - startComponents[1]) * progress
        let blue = startComponents[2] + (endComponents[2] - startComponents[2]) * progress
        let alpha = startComponents[3] + (endComponents[3] - startComponents[3]) * progress

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

#Preview {
    CCDashedStrokeCircle(strokeCount: 28, customColors: [3:.black])
}
