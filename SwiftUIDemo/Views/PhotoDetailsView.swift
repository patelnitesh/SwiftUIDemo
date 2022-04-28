//
//  PhotoDetailsView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct PhotoDetailsView: View {
    let flickrPhoto: FlickrPhoto
    var body: some View {
        Text(flickrPhoto.id)
    }
}

struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let flickrPhoto = FlickrPhoto(id: "Some ID")
        PhotoDetailsView(flickrPhoto: flickrPhoto)
    }
}
