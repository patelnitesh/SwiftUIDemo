//
//  PublicFeedView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct PublicFeedView: View {
    @State var photoItems : [Item] = []

    var body: some View {
        NavigationView{
            ScrollView{
                LazyVStack(alignment: .center){
                    ForEach(photoItems, id:\.authorID) { item in
                        NavigationLink(destination: PhotoView(selectedItem: item)){
                            AsyncImageView(url: item.media.m)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Trending Feed"))
            .task {
                do {
                    photoItems = try await ApiClient().publicFeed()
                } catch{
                    print("Error loading data")
                }
            }
        }
    }
}

struct PublicFeedView_Previews: PreviewProvider {
    static var previews: some View {
        PublicFeedView()
    }
}
