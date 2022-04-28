//
//  SearchResponse.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

struct Response: Codable {
    var photos: Photos
    var stat: String
}


struct Photos: Codable{
    var page: Int = 1
    var pages: Int = 1
    var perpage: Int = 12
    var total: Int
    var photo: [Photo]
}

struct Photo: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
    var url_t: String?
    var height_t: Float?
    var width_t: Float?
    
    var url_m: String?
    var height_m: Int?
    var width_m: Int?
    
    var url_l: String?
    var height_l: Float?
    var width_l: Float?
}
