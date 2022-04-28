//
//  SearchView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var photoListVM = SearchListViewModel()

    @State private var searchText: String = "Gardenn"
    @State var isSearchingTAGs = false
    
    var body: some View {
        NavigationView {
            VStack{
                Toggle("**Search By Tags**", isOn:
                        $isSearchingTAGs)
                .padding([.leading, .trailing])
                .onChange(of: isSearchingTAGs) { newValue in
                    print("toggle has change")
                    Task {
                        await photoListVM.search(text: searchText, isSearchingTag: isSearchingTAGs)
                    }
                }
                
                
                List(photoListVM.photos, id:\.id) { photo in
                    VStack {
                        AsyncImageView(url: photo.url_m ?? "")
                            .aspectRatio(contentMode: .fit)
                        Text(photo.title)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .searchable(text: $searchText)
                .onChange(of: searchText) { value in
                    Task {
                        if !value.isEmpty &&  value.count > 3 {
                            await photoListVM.search(text: value, isSearchingTag: isSearchingTAGs)
                        } else {
                            photoListVM.photos.removeAll()
                        }
                    }
                }
            }
            .navigationTitle("Result for \(searchText)")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
