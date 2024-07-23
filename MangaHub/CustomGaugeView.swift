//
//  CustomGaugeView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 18/07/24.
//

import SwiftUI

// En esta vista podemos seleccionar el tamaño de la vista para ser reutilizada, y podemos escoger si queremos que el valor mostrado como porcentaje o no, usando una escala como el valor total. Ejemplo: El valor puede ser 1 y la escala 10. Por lo tanto, podemos presentar como valor el 1.0 o 10% ya que 1 es el 10% de 10.

struct CustomGaugeView: View {
    
    @State private var progress: Bool = false
    @State var isPercentage: Bool
    var value: Double
    var scale: Double
    var size: GaugeSize
    
    var body: some View {
        ZStack {
            // Valor que será mostrado como porcentaje o no.
            Text(isPercentage ? "\(Int((value / scale) * 100)) %" : "\(value.formatted(.number.precision(.fractionLength(1))))")
                .font(size == .large ? .system(size: 40, weight: .bold, design: .rounded) : .system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .padding(size == .large ? 20 : 10)
                .background(Circle().fill(Color.white).frame(width: size == .large ? 200 : 50, height: size == .large ? 200 : 50))
            
            // Vista del progreso que hace las veces de lo que hace falta por ser completado
            Circle()
                .stroke(lineWidth: size == .large ? 24 : 6)
                .frame(width: size == .large ? 200 : 50, height: size == .large ? 200 : 50)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: size == .large ? 10 : 2, x: size == .large ? 10 : 2, y: size == .large ? 10 : 2)
            
            // Vista del progreso que muestra lo que se ha completado
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

enum GaugeSize {
    case small
    case large
}

#Preview {
    VStack {
        CustomGaugeView(isPercentage: true, value: 7, scale: 10.0, size: .large)
            .padding()
        CustomGaugeView(isPercentage: false, value: 7, scale: 10.0, size: .small)
            .padding()
    }
}

