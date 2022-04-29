//
//  PhotoResponse.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

// MARK: - PhotoResponse
struct PhotoResponse: Codable {
    let photo: PhotoModel
    let stat: String

}

// MARK: - Photo
struct PhotoModel: Codable {
    let id, secret, server: String
    let farm: Int
    let dateuploaded: String
    let owner: Owner
    let title, photoDescription: Description
    let dates: Dates
    let views: String
    let tags: Tags
    let urls: Urls
    let media: String

    enum CodingKeys: String, CodingKey {
        case photoDescription = "description"
        case id, secret, server, farm, dateuploaded
        case owner, title, dates, views, tags, urls, media
    }
    
    // Canvert date 
    //let uploadedDate = DateFormatter().String(Date(timeIntervalSince1970: Double(dateuploaded)))
    
}

// MARK: - Comments
struct Comments: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let posted, taken: String
    let takengranularity: Int
    let takenunknown: String
    let lastupdate: String
}

// MARK: - Editability
struct Editability: Codable {
    let cancomment, canaddmeta: Int
}

// MARK: - Notes
struct Notes: Codable {
    let note: [String]?
}

// MARK: - Owner
struct Owner: Codable {
    let nsid, username, realname: String
    let location: String?
    let iconserver: String
    let iconfarm: Int
    let pathAlias: String?

    enum CodingKeys: String, CodingKey {
        case nsid, username, realname, location, iconserver, iconfarm
        case pathAlias = "path_alias"
    }
}

// MARK: - People
struct People: Codable {
    let haspeople: Int
}

// MARK: - Description
struct Description: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

// MARK: - Tags
struct Tags: Codable {
    let tag: [Tag]
}

// MARK: - Tag
struct Tag: Codable {
    let id, author, authorname, raw: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case id, author, authorname, raw
        case content = "_content"
    }
}

// MARK: - Urls
struct Urls: Codable {
    let url: [URLElement]
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case type
        case content = "_content"
    }
}

// MARK: - Usage
struct Usage: Codable {
    let candownload, canblog, canprint, canshare: Int
}

// MARK: - Visibility
struct Visibility: Codable {
    let ispublic, isfriend, isfamily: Int
}
