//
//  PublicFeedView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct PublicFeedView: View {
    @ObservedObject var randomeFeed = RandomFeedData()
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVStack(alignment: .center){
                    ForEach(randomeFeed.photoItems, id:\.authorID) { item in
                        NavigationLink(destination: PhotoView(selectedItem: item)){
                            AsyncImageView(url: item.media.m)
                        }
                    }
                }
            }.navigationBarTitle(Text("Trending Feed"))
        }
    }
}

struct PublicFeedView_Previews: PreviewProvider {
    static var previews: some View {
        PublicFeedView()
    }
}
