//
//  MangaHubApp.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

@main
struct MangaHubApp: App {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                if showSplash {
                    LaunchScreenView()
                        .transition(.opacity)
                } else {
                    
                    if isFirstLaunch {
                        OnboardingView(isFirstLaunch: $isFirstLaunch)
                    } else {
                        MainTabItemView()
                            
                    }
                }
            }
            .onAppear {
                Task {
                    try? await Task.sleep(for: .milliseconds(1000))
                    withAnimation(.easeOut(duration: 1)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
