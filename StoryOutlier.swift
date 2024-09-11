//
//  CCDashedStrokeCircle.swift
//  Blindstory
//
//  Created by Deniz Aydemir on 10.09.2024.
//  Copyright © 2024 Deniz Aydemir. All rights reserved.
//

import SwiftUI

struct CCDashedStrokeCircle: View {
//    let strokeCount: Int
    let gapDegrees: Double  // Customize the gap between segments
//    let customColors: [Int: Color]
    let isWatchedList: [Bool]
    let innerCircleSize: CGFloat
    let innerOuterCircleGap: CGFloat
    
   
    
    
    init(/*strokeCount: Int, */isWatchedList: [Bool], innerCircleSize: CGFloat, innerOuterCircleGap: CGFloat) {
//        self.strokeCount = strokeCount
        self.isWatchedList = isWatchedList
        self.gapDegrees = CCDashedStrokeCircle.calculateDashGap(count: isWatchedList.count)
        self.innerCircleSize = innerCircleSize
        self.innerOuterCircleGap = innerOuterCircleGap
    }
    
    var body: some View {
        if isWatchedList.count == 1 {
            if isWatchedList[0] {
                SegmentView(strokeCount: isWatchedList.count, gapDegrees: gapDegrees)
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 3.34, lineCap: .round, lineJoin: .round))
                    .frame(width: innerCircleSize + innerOuterCircleGap, height: innerCircleSize + innerOuterCircleGap)
            } else {
                SegmentView(strokeCount: isWatchedList.count, gapDegrees: gapDegrees)
                    .stroke(RadialGradient(gradient: Gradient(colors: [CustomColor.radialGradient1, CustomColor.radialGradient2, CustomColor.radialGradient3]), center: .topLeading, startRadius: 0, endRadius: 130),style: StrokeStyle(lineWidth: 3.34, lineCap: .round, lineJoin: .round))
                    .frame(width: innerCircleSize + innerOuterCircleGap, height: innerCircleSize + innerOuterCircleGap)
            }
        } else {
            ZStack {
                ForEach(0..<isWatchedList.count, id: \.self) { index in
                    SegmentView(strokeCount: isWatchedList.count, gapDegrees: gapDegrees)
                    
                        .stroke(style: StrokeStyle(lineWidth: 3.34, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(Double(index) * (360.0 / Double(isWatchedList.count))))
                        .foregroundStyle(colorForSegment(index: index))
//                        .foregroundStyle(Color.red)

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
            .frame(width: innerCircleSize + innerOuterCircleGap, height: innerCircleSize + innerOuterCircleGap)
        }
    }
    
    func colorForSegment(index: Int) -> Color {
        if isWatchedList[index] {
            return Color.gray
        } else {
            let colorProgress = (Double(index) / Double(isWatchedList.count)) + (1 / Double(2 * isWatchedList.count)) // Center of the segment
            let segmentColor = UIColor.interpolateGradientColors(colorStops: CustomColor.circularColorStops, progress: CGFloat(colorProgress))
            return Color(segmentColor)
        }
    }
    
    private static func calculateDashGap(count: Int) -> Double {
        if count > 70 {
            return 4.4
        } else if count > 30 {
            return 5
        } else {
            return 6
        }
    }
}

extension UIColor {
    static func interpolateGradientColors(colorStops: [(UIColor, CGFloat)], progress: CGFloat) -> UIColor {
        let relevantStops = colorStops.sorted { $0.1 < $1.1 }
        let lastIndex = relevantStops.lastIndex { progress >= $0.1 } ?? relevantStops.count - 1
        let nextIndex = min(lastIndex + 1, relevantStops.count - 1)
        
        let startStop = relevantStops[lastIndex]
        let endStop = relevantStops[nextIndex]
        let localProgress = (progress - startStop.1) / (endStop.1 - startStop.1)

        return interpolateColorTo(start: startStop.0, end: endStop.0, progress: localProgress)
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


struct SegmentView: Shape {
    var strokeCount: Int
    var gapDegrees: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.width / 2
        let totalGap = strokeCount == 1 ? 0 : gapDegrees * Double(strokeCount)  // Total gap degrees in the circle
        let segmentDegrees = (360.0 - totalGap) / Double(strokeCount)
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(segmentDegrees),
                    clockwise: false)
        return path
    }
}

#Preview {
    CCDashedStrokeCircle(/*strokeCount: 2, */isWatchedList: [true,false,false], innerCircleSize: 78, innerOuterCircleGap: 4)
}
