//
//  PhotoView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct PhotoView: View {
    let selectedItem: Item
    @State private var photoModel: PhotoModel!
    @State private var isShowingDetailView = false
    @State private var isShowingSheet = false


    var body: some View {
        VStack(){
            FullPhotoView(url: selectedItem.media.m)
            if let photoModel = photoModel {
                NavigationLink(destination: PhotoMetaDataView(photoModel: photoModel), isActive: $isShowingDetailView) { EmptyView() }
                Text("\(photoModel.title) " + "by" + " \(photoModel.owner.realname)")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {

            Button {
                print("Handle if no PhotoModel than please show Error")
                isShowingDetailView = true
            } label: {
                Image(systemName: "info.circle")
            }
            
            Button {
                print("Share Tapped")
                isShowingSheet = true
                
            } label: {
                Image(systemName: "square.and.arrow.up")
            }.sheet(isPresented: $isShowingSheet,
                    content: {
                     ActivityView(activityItems: [NSURL(string: "https://www.flickr.com/photos/flickr/galleries/")!] as [Any], applicationActivities: nil) })
            }
        }
        .task {
            do {
                guard let selectedPhotoID = selectedItem.link.components(separatedBy: "/").dropLast().last else { return }
                photoModel = try await ApiClient().loadPhoto(photoId: selectedPhotoID)
            } catch{
                print("Error loading data")
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedItem = Item(title: "String", link: "String", media: Media(m: ""), dateTaken: Date(), itemDescription: "", published: Date(), author: "", authorID: "", tags: "")
        PhotoView(selectedItem:selectedItem)
    }
}


struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}
