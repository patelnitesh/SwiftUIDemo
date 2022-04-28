//
//  RandomFeedData.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import Foundation

class RandomFeedData: ObservableObject {
    @Published var photoItems : [Item] = []
    
    init() {
        loadRandomFeedData()
    }
    
    func loadRandomFeedData()  {
        guard let url = URL(string:publicFeedURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _ , error) in
            guard let data = data else {
                print("URLSeecion dataTask error:", error ?? "nil")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                if let decodedResponse = try? decoder.decode(PublicFeedResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.photoItems = decodedResponse.items
                        print("*** ",self.photoItems.count)
                    }
                }
            } catch { // TODO : handle Error and remove warning
                print("Invalid data - Handle Error")
            }
        }.resume()
    }
}
