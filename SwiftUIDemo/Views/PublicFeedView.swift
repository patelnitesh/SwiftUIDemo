//
//  PublicFeedView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

enum Sorting: String {
    case PublishDate
    case TakenDate
}

struct PublicFeedView: View {
    @State var photoItems: [Item] = []
    @State private var sortedBy = Sorting.PublishDate
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    // TODO: Update picker style in line with new desgin 
                    Picker("Sorted by", selection: $sortedBy) {
                        Text("Published Date").tag(Sorting.PublishDate)
                        Text("Taken Date").tag(Sorting.TakenDate)
                    }
                    .pickerStyle(.segmented)

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
