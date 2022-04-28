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
}

// MARK: - Media
struct Media: Codable {
    let m: String
}

struct FlickrPhoto {
    let id: String
    let photoModel: PhotoModel? = nil
    let photoExif: PhotoExif? = nil 
}
