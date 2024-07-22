//
//  OnboardingView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 13/07/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var selectedIndex = 0
    @Binding var isFirstLaunch: Bool
    var pages = Page.pages
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                TabView(selection: $selectedIndex) {
                    ForEach(pages) { page in
                        VStack {
                            
                            PageView(page: page)
                            
                            HStack {
                                if selectedIndex > 0 {
                                    Button {
                                        if selectedIndex > 0 {
                                            selectedIndex -= 1
                                        }
                                    } label: {
                                        Text("Previous")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(.mangaHubColor)
                                            .bold()
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.horizontal)
                                    }
                                    
                                }
                                
                                Button {
                                    if page.id == pages.last?.id {
                                        isFirstLaunch = false
                                    } else {
                                        selectedIndex += 1
                                    }
                                } label: {
                                    if page.id == pages.last?.id {
                                        Text("Go to the app!")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(.white)
                                            .bold()
                                            .background(Color.mangaHubColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.horizontal)
                                    } else {
                                        Text("Next")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(.white)
                                            .bold()
                                            .background(Color.mangaHubColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.horizontal)
                                    }
                                }
                                
                            }
                            .offset(y: 300)
                            
                            Spacer()
                        }
                        .tag(page.tag)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isFirstLaunch = false
                        } label: {
                            Text(selectedIndex == 3 ? "Continue to the App" : "Skip")
                                .bold()
                                .foregroundStyle(Color.mangaHubColor)
                        }
                    }
                }
                .animation(.easeInOut, value: selectedIndex)
                .tabViewStyle(.page)
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .systemPink
                    UIPageControl.appearance().pageIndicatorTintColor = .white
                    UIPageControl.appearance().isHidden = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(true))
}






