//
//  OnboardingView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 13/07/24.
//

import SwiftUI

// Vista que contiene el TabView, el cual recibe las vistas a partir de la 'PageView'. Contiene un 'selectedIndex' para identificar la página en la que nos encontramos y así realizar la lógica de los botones. Además, desde aquí establecemos el valor de 'isFirstLaunch' a 'False' y queda guardado gracias al property wrapper '@AppStorage'.

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
                    UIPageControl.appearance().isHidden = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(true))
}






