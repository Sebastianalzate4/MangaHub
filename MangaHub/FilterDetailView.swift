//
//  FilterDetailView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 17/07/24.
//

import SwiftUI

struct FilterDetailView: View {
    
    @ObservedObject var viewmodel: DetailViewModel
    @State private var selection: InformationButtons = .description
    @Namespace private var namespace
    @State var isExpanded: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            ForEach(InformationButtons.allCases) { option in
                VStack(spacing: 8) {
                    Text(option.title)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if selection == option {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(height: 1.5)
                            .matchedGeometryEffect(id: "ID", in: namespace)
                    }
                }
                .padding(.top, 8)
                .background(Color.black.opacity(0.0001))
                .foregroundStyle(selection == option ? Color.mangaHubColor : .gray)
                .onTapGesture {
                    selection = option
                }
            }
        }
        .animation(.smooth, value: selection)
        
        switch selection {
            
        case .description:
            Text(viewmodel.manga.sypnosis ?? "")
                .multilineTextAlignment(.leading)
                .lineLimit(isExpanded ? nil : 5)
                .truncationMode(.middle)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "Show Less" : "Read More")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.mangaHubColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
        case .authors:
            
            Text("Explore a curated list of manga created by the authors behind **\(viewmodel.manga.title)**. Click on an author's name to discover their complete works.")
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(viewmodel.manga.authors) { author in
                        NavigationLink(value: author) {
                            
                            HStack {
                                Text(author.authorCompleteName)
                                Image(systemName: "chevron.right")
                            }
                            
                            .padding()
                            .font(.system(.headline, design: .rounded))
                            .bold()
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .background(Color.mangaHubColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                        }
                    }
                }
                .padding(.init(top: 10, leading: 20, bottom: 30, trailing: 40))
            }
            
        case .details:
            
            
            DetailsSectionView(manga: viewmodel.manga)
            
        }
    }
}

#Preview {
    FilterDetailView(viewmodel: DetailViewModel(manga: .preview))
}
