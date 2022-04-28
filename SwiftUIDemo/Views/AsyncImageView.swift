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
                Image(systemName: "photo")
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: UIScreen.main.bounds.width - 50, height: 400, alignment: .center)
        .cornerRadius(10)
    }
}
