//
//  PublicFeedView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

enum Sorting: String {
    case PublishDate = "Published Date"
    case TakenDate = "Taken Date"
}

struct PublicFeedView: View {
    @State var photoItems: [Item] = []
    @State private var sortedBy = Sorting.PublishDate
    
    var body: some View {
        NavigationView {
            VStack{
                    Picker("Sorted by", selection: $sortedBy) {
                        Text(Sorting.PublishDate.rawValue).tag(Sorting.PublishDate)
                        Text(Sorting.TakenDate.rawValue).tag(Sorting.TakenDate)
                    }
                    .pickerStyle(.segmented)
                    .padding(10)
                
                    ScrollView{
                        LazyVStack{
                            ForEach(photoItems, id: \.picID) { photo in
                                NavigationLink(destination:PhotoDetailsView(flickrPhotos: flickrPhotos(), picID: photo.picID)){
                                    AsyncImageView(url: photo.media.m)
                                }

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
            print("pic id",item.picID)
            return FlickrPhoto(id: item.picID,
                        imageURL:item.media.m.replacingOccurrences(of: "_m", with: "_b"))

        }
        
        return filckrphotos
    }
    
    
    /// Try and use comparable protocol for Dates
    /// https://medium.com/nerd-for-tech/equatable-hashable-and-comparable-d782449f6ce8
    /// Result sorted by relevant Dates
    private func sortedResultBy() {
        switch sortedBy {
        case .PublishDate:
            photoItems = photoItems.sorted(by: { $0.dateTaken > $1.dateTaken })
        case .TakenDate:
            photoItems = photoItems.sorted(by: { $0.published > $1.published })
        }
    }
}

struct PublicFeedView_Previews: PreviewProvider {
    static var previews: some View {
        PublicFeedView()
    }
}
