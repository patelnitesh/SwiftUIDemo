//
//  PublicFeedResponse.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

struct PublicFeedResponse: Codable {
    let title: String
    let link: String
    let description: String
    let modified: Date
    let generator: String
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case title, link
        case description = "description"
        case modified, generator, items
    }
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: Date
    let itemDescription: String
    let published: Date
    let author, authorID, tags: String

    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case itemDescription = "description"
        case published, author
        case authorID = "author_id"
        case tags
    }
    
    // MARK: Public feed does not have 
    var picID : String {
        guard let selectedPhotoID = link.components(separatedBy: "/").dropLast().last else {
            return "unknown"
        }
        return selectedPhotoID
    }
}

extension  Item {
    static var dummyData: [Item] {
        let dummyItem = Item(title: "Tile",
              link: "https://www.flickr.com/photos/47676646@N08/52050922647/",
              media: Media(m: "https://live.staticflickr.com/65535/52050922647_691336c3fe_m.jpg"),
              dateTaken: Date(),
              itemDescription: "<p><a href=\"https://www.flickr.com/people/47676646@N08/\">jambox998</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/47676646@N08/52050922647/\" title=\"20220424_075400\"><img src=\"https://live.staticflickr.com/65535/52050922647_691336c3fe_m.jpg\" width=\"240\" height=\"180\" alt=\"20220424_075400\" /></a></p> ",
              published: Date(),
              author: "nobody@flickr.com (\"jambox998\")",
              authorID: "47676646@N08",
              tags: "instagram filter")
        
        return [dummyItem]
    }
}

// MARK: - Media
struct Media: Codable {
    let m: String
}

// MARK: Flickr Photo to pass data to different views
struct FlickrPhoto {
    let id: String
    let photoModel: PhotoModel? = nil
    let photoExif: PhotoExif? = nil
    let imageURL: String
    let owner: String
    let title: String

    init(id: String,
         photoModel: PhotoModel? = nil,
         photoExif: PhotoExif? = nil,
         imageURL: String,
         owner: String = "",
         title: String = "") {
        self.id = id
        self.imageURL = imageURL
        self.owner = owner
        self.title = title
    }
}
