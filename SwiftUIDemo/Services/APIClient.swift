//
//  APIClient.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

let APIKEY = "bde1fb6314569ba8b2ef3d2e42392424"
let publicFeedURL = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"

enum NetworkError: Error {
    case badURL
    case badID
}

class ApiClient {
    
    func getFlickrPhotos(searchText: String, searchTag: String) async throws -> [Photo] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: APIKEY),
            URLQueryItem(name: "tags", value: searchTag.trimmed()),
            URLQueryItem(name: "text", value: searchText.trimmed()),
            URLQueryItem(name: "extras", value: "url_m"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }

        print ("URL : ",url)
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedResponse = try? decoder.decode(Response.self, from: data)
        
        return decodedResponse?.photos.photo ?? []
        
    }
}
