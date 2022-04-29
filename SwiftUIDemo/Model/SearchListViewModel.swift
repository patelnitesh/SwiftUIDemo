//
//  SearchListViewModel.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation
@MainActor
class SearchListViewModel: ObservableObject {
    
    @Published var photos: [Photo]
    
    @MainActor init() {
        photos = []
    }
    
    func search(text: String, isSearchingTag: Bool) async {
        do {
            let tags = isSearchingTag ? text : ""
            let searchText = isSearchingTag ? "" : text
            let photos = try await ApiClient().getFlickrPhotos(searchText: searchText, searchTag: tags)
            self.photos = photos
        } catch {
            print(error)
        }
    }
    
    // MARK: - Map Public Photo into FlickerPhoto and returns as array
    func convertedToFlickerPhotos() -> [FlickrPhoto] {
        let filckrphotos = photos.map { photo -> FlickrPhoto in
            return FlickrPhoto(id: photo.id,
                        imageURL:photo.url_m ?? "",
                        owner: photo.owner,
                        title: photo.title)
        }
        return filckrphotos
    }
    
}
