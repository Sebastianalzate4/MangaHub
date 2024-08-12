//
//  PageView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 15/07/24.
//

import SwiftUI

// Vista que contiene la estructura del Onboarding de la app. La imagén, el título y la descripción. Recibe estos valores a partir de la estructura 'Page'. Por otro lado, los botones reciben su acción desde la OnboardingView.

struct PageView: View {
    
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    let deviceType = UIDevice.current.userInterfaceIdiom
    var page: Page
    var showPrevious: Bool
    var onPrevious: () -> Void
    var onNext: () -> Void

    var body: some View {

        if deviceType == .phone && heightSizeClass == .regular {
            VStack {
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Text(page.title)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    if showPrevious {
                        Button {
                            onPrevious()
                        } label: {
                            Text("Previous")
                                .mangaHubButton(color: Color.black)
                        }
                    }
                    
                    Button {
                        onNext()
                    } label: {
                        Text(page.id == Page.pages.last?.id ? "Start!" : "Next")
                            .mangaHubButton(color: Color.mangaHubColor)
                    }
                }
                .padding(.top, 10)
            }
        } else {
            HStack {
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                VStack {
                    Text(page.title)
                        .font(deviceType == .phone ? .system(size: 40, weight: .regular, design: .rounded) : .system(size: 60, weight: .regular, design: .rounded))
                        .bold()
                        .padding()
                    
                    Text(page.description)
                        .font(deviceType == .phone ? .system(size: 20, weight: .regular, design: .rounded) : .system(size: 25, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack {
                        if showPrevious {
                            Button {
                                onPrevious()
                            } label: {
                                Text("Previous")
                                    .font(deviceType == .phone ? .system(size: 20, weight: .regular, design: .rounded) : .system(size: 25, weight: .regular, design: .rounded))
                                    .mangaHubButton(color: Color.black)
                            }
                        }
                        
                        Button {
                            onNext()
                        } label: {
                            Text(page.id == Page.pages.last?.id ? "Start!" : "Next")
                                .font(deviceType == .phone ? .system(size: 20, weight: .regular, design: .rounded) : .system(size: 25, weight: .regular, design: .rounded))
                                .mangaHubButton(color: Color.mangaHubColor)
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}


#Preview {
    PageView(page: Page.pages[1], showPrevious: true) {
        // Acción cuando se toca el botón "Previous"
        print("Previous tapped")
    } onNext: {
        // Acción cuando se toca el botón "Next"
        print("Next tapped")
    }
}
