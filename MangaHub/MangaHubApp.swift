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
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                // Cuando iniciamos la app mostramos la 'LaunchScreenView' siempre y una vez terminada la Task.sleep, se deja de mostrar.
                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.opacity)
                } else {
                    // Cuando iniciamos la app por primera vez mostramos la 'OnboardingView' y una vez establezcamos a false la variable 'isFirstLaunch' desde esta vista, empezaremos a mostrar la 'MainTabItemView'.
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
                        showLaunchScreen = false
                    }
                }
            }
        }
    }
}
