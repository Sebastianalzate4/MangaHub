//
//  CustomGaugeView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 18/07/24.
//

import SwiftUI

enum GaugeSize {
    case small
    case large
}

struct CustomGaugeView: View {
    
    @State private var progress: Bool = false
    var value: Double
    var scale: Double
    @State var isPercentage: Bool
    var size: GaugeSize
    
    var body: some View {
        ZStack {
            Text(isPercentage ? "\(Int((value / scale) * 100)) %" : "\(value.formatted(.number.precision(.fractionLength(1))))")
                .font(size == .large ? .system(size: 40, weight: .bold, design: .rounded) : .system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(size == .large ? 20 : 10)
                    .background(Circle().fill(Color.white).frame(width: size == .large ? 200 : 50, height: size == .large ? 200 : 50))

            Circle()
                .stroke(lineWidth: size == .large ? 24 : 6)
                .frame(width: size == .large ? 200 : 50, height: size == .large ? 200 : 50)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: size == .large ? 10 : 2, x: size == .large ? 10 : 2, y: size == .large ? 10 : 2)
            
            Circle()
                .trim(from: 0, to: progress ? (value / scale) : 0)
                .stroke(style: StrokeStyle(lineWidth: size == .large ? 24 : 6, lineCap: .round))
                .fill(Color.mangaHubColor)
                .frame(width: size == .large ? 200 : 50, height: size == .large ? 200 : 50)
                .rotationEffect(.degrees(-90))
        }
        .padding(size == .large ? 0 : 6)
        .onAppear {
            withAnimation(.spring().speed(0.2)) {
                progress = true
            }
        }
    }
}

#Preview {
    VStack {
        CustomGaugeView(value: 7, scale: 10.0, isPercentage: true, size: .large)
            .padding()
        CustomGaugeView(value: 7, scale: 10.0, isPercentage: false, size: .small)
            .padding()
    }
}

