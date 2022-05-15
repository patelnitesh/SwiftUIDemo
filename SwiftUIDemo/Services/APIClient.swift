//
//  APIClient.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

let APIKEY = "bde1fb6314569ba8b2ef3d2e42392424"
let PUBLIC_FEED_BASE_URL = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
let BASE_URL = "https://www.flickr.com/services/rest/?"
let PHOTO_URL = "method=flickr.photos.getInfo&api_key=\(APIKEY)&format=json&nojsoncallback=1&safe_search=1"
let EXIF_URL = "method=flickr.photos.getExif&api_key=\(APIKEY)&format=json&nojsoncallback=1&safe_search=1"

/// Because Public feed does not return safe search results. I have used some random Accounts
let RANDOM_AUTHOR_IDS = ["53035251@N03","80635996@N02","28458481@N06","28726735@N08","24689012@N07,193317354@N08,70091193@N06"]
let ADD_RANDOM_IDS = "&ids=\(RANDOM_AUTHOR_IDS.choose(2).joined(separator: ","))"


enum NetworkError: Error {
    case badURL
    case badID
    case badData
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

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedResponse = try? decoder.decode(Response.self, from: data)
        return decodedResponse?.photos.photo ?? []
        
    }
    
    func loadPhoto(photoId: String) async throws -> PhotoModel?  {
        
        print("Loading for PhotoId ",photoId)
        let photoURL = BASE_URL + PHOTO_URL + "&photo_id=\(photoId)"

        guard let url = URL(string:photoURL) else {
            throw NetworkError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        guard let photoModel = try? decoder.decode(PhotoResponse.self, from: data).photo else {
            throw NetworkError.badData
        }
        return photoModel
    }
    
    func loadMetaData(photoId: String) async throws -> PhotoExif?  {
        let photoExifURL = BASE_URL + EXIF_URL + "&photo_id=\(photoId)"

        guard let url = URL(string:photoExifURL) else {
            throw NetworkError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let photoExif = try? decoder.decode(PhotoExifResponse.self, from: data).photo else {
            throw NetworkError.badData
        }
        return photoExif
    }
    
    func publicFeed() async throws -> [Item]  {
        // SAFE search is not available for some images
        // Will try with URL: ",PUBLIC_FEED_BASE_URL + ADD_RANDOM_IDS)
        guard let url = URL(string:PUBLIC_FEED_BASE_URL) else {
            throw NetworkError.badURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
                
        guard let photos = try? decoder.decode(PublicFeedResponse.self, from: data).items else {
            throw NetworkError.badData
        }
        return photos
    }
}

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
