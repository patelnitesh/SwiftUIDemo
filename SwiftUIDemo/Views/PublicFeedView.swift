//
//  PublicFeedView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct PublicFeedView: View {
    @State var photoItems: [Item] = []
    @State private var sortedBy = "PublishedDate"
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Picker("Sorted by", selection: $sortedBy) {
                        Text("Published Date").tag("PublishedDate")
                        Text("Taken Date").tag("TakenDate")
                    }

                    List{
                        ForEach(photoItems, id: \.picID) { item in
                            NavigationLink(destination:PhotoDetailsView(flickrPhotos: flickrPhotos(),picID: item.picID)){
                                AsyncImageView(url: item.media.m)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Public Feed"))
            .task {
                await loadData()
            }
            .onChange(of: sortedBy) { newValue in
                sortedResultBy()
            }
        }
        .refreshable {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            photoItems = try await ApiClient().publicFeed()
            sortedResultBy()
        } catch{
            print("Error loading data")
        }
    }
    
    /// Map Public Photos info into FlickerPhoto and returns as array
    private func flickrPhotos() -> [FlickrPhoto] {
        let filckrphotos = photoItems.map { item -> FlickrPhoto in
            FlickrPhoto(id: item.link.components(separatedBy: "/").dropLast().last ?? "NoID",
                        imageURL:item.media.m.replacingOccurrences(of: "_m", with: "_b"))
        }
        return filckrphotos
    }
    
    /// Result sorted by relavent Dates
    private func sortedResultBy(){
        if sortedBy == "PublishedDate" {
            photoItems = photoItems.sorted(by: { $0.dateTaken > $1.dateTaken })
        } else if sortedBy == "TakenDate" {
            photoItems = photoItems.sorted(by: { $0.published > $1.published })
        }
    }
}

struct PublicFeedView_Previews: PreviewProvider {
    static var previews: some View {
        PublicFeedView()
    }
}
