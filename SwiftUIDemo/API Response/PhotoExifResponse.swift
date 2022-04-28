//
//  PhotoExifResponse.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

// MARK: - PhotoExifResponse
struct PhotoExifResponse: Codable {
    let photo: PhotoExif
    let stat: String
}

// MARK: - Photo
struct PhotoExif: Codable {
    let id, secret, server: String
    let farm: Int
    let camera: String
    let exif: [Exif]
}

// MARK: - Exif
struct Exif: Codable, Hashable {
    let tagspace: String?
    let tagspaceid: Int
    let tag: String
    let label: String
    let raw: Clean
    let clean: Clean?
    
    static func == (lhs: Exif, rhs: Exif) -> Bool {
        lhs.tagspace == rhs.tagspace &&
        lhs.tagspaceid == rhs.tagspaceid &&
        lhs.tag == rhs.tag &&
        lhs.label == rhs.label &&
        lhs.raw == rhs.raw &&
        lhs.clean == rhs.clean
    }
}

// MARK: - Clean
struct Clean: Codable, Hashable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
