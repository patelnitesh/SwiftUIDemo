//
//  PhotoMetaDataView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct PhotoMetaDataView: View {
    let photoModel: PhotoModel!
    @State private var photoExifModel: PhotoExif!

    var body: some View {
        VStack(){
            if let photoExifModel = photoExifModel {
                MetaDataView(photoExifModel: photoExifModel, photoModel: photoModel)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
              Text("Meta Data")
                .fontWeight(.bold)
            }
        }
        .task {
            do {
                photoExifModel = try await ApiClient().loadMetaData(photoId: "52023860981")
            } catch{
                print("Error loadig data")
            }
        }
    }
}

struct PhotoMetaDataView_Previews: PreviewProvider {
    static var previews: some View {
        // This will crash
        let photoModel = Bundle.main.decode(PhotoResponse.self, from: "DummyPhotoModel.json").photo
        PhotoMetaDataView(photoModel: photoModel)
    }
}

struct MetaDataView: View {
    let photoExifModel: PhotoExif
    let photoModel: PhotoModel

    var body: some View {
        NavigationView {
                VStack(alignment: .leading, spacing: 15) {
                    if let photoExifModel = photoExifModel {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .center,spacing: 5){
                                Text("Photo id :")
                                    .bold()
                                Text(photoExifModel.id)
                            }
                            HStack(alignment: .center,spacing: 5){
                                Text("Camera :")
                                    .bold()
                                Text(photoExifModel.camera)
                            }
                            
                            HStack(spacing: 5) {
                                Text("Exif Count :").bold()
                                Text("\(photoExifModel.exif.count)")
                            }
                            
                            HStack(alignment: .center,spacing: 5){
                                Text("Title :")
                                    .bold()
                                Text(photoModel.title.content)
                            }
                            HStack(spacing: 5) {
                                Text("Owner :").bold()
                                Text(photoModel.owner.realname)
                            }
                            HStack(spacing: 5) {
                                Text("Taken on :").bold()
                                Text(photoModel.dates.taken)
                            }
                            HStack(spacing: 5) {
                                Text("Views :").bold()
                                Text(photoModel.views)
                            }
                            HStack(spacing: 5) {
                                Text("Tags :").bold()
                                Text("\(photoModel.tags.tag.map{ $0.raw}.joined(separator: ", "))")
                            }
                            
                        }.padding(10)
                        
                        List {
                            ForEach(photoExifModel.exif, id:\.self) { exif in
                                HStack(alignment: .center,spacing: 5){
                                    Text("\(exif.label) :").bold()
                                    Text(exif.raw.content)
                                }
                            }}
                    } else {
                        ProgressView()
                    }
                
                }
                .navigationBarTitle("Meta Data")
                .navigationBarTitleDisplayMode(.inline)
            }
    }
}
