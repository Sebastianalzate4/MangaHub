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
                Color.white
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
                                            .font(.title3)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(.white)
                                            .bold()
                                            .background(Color.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.black, lineWidth: 0.5)
                                            )
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
                                        Text("Start!")
                                            .font(.title3)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(.white)
                                            .bold()
                                            .background(Color.mangaHubColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.black, lineWidth: 0.5)
                                            )
                                            .padding(.horizontal)
                                    } else {
                                        Text("Next")
                                            .font(.title3)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(.white)
                                            .bold()
                                            .background(Color.mangaHubColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.black, lineWidth: 0.5)
                                            )
                                            .padding(.horizontal)
                                            
                                    }
                                }
                                
                            }
                            .offset(y: 50)
                            
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
                    UIPageControl.appearance().currentPageIndicatorTintColor = .orange
                    UIPageControl.appearance().pageIndicatorTintColor = .secondaryLabel
                    UIPageControl.appearance().isHidden = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(true))
}






