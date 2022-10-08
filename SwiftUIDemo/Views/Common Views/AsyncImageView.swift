//
//  AsyncImageView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct AsyncImageView: View {
    var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { media in
            if let image = media.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if media.error != nil {
                ZStack(alignment: .bottomTrailing){
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .scaledToFill()
                    Text("There was an error loading the image.")
                        .padding(0)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .offset(x: -5, y: -5)
                }
            } else {
                ProgressView()
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}
