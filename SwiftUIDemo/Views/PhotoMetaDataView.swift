//
//  PhotoMetaDataView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI
import Foundation

struct PhotoMetaDataView: View {
    let photoModel: PhotoModel!
    @State private var photoExifModel: PhotoExif!
    @State private var displayDictionary: Dictionary<String, String> = [:]
    
    var body: some View {
        VStack(){
            List {
                ForEach(displayDictionary.sorted(by: <), id: \.key) { key, value in
                    HStack{
                        image(for: key, value: value)?
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                        VStack(alignment: .leading,spacing: 5){
                            Text(key).bold()
                            Text(value)
                        }
                    }
                }
                if photoExifModel == nil {
                    ProgressView()
                } else {
                    EmptyView()
                }
            }
        }.onAppear(){
            displayDictionary = headerSectionInfo()
        }
        .navigationBarTitle("Meta Data")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                photoExifModel = try await ApiClient().loadMetaData(photoId: photoModel.id)
                appendExifInfo()
            } catch{
                print("Error loadig data")
            }
        }
    }
    
    private func headerSectionInfo() -> Dictionary<String, String> {
        var displayinfo: [String: String] = [:]
        displayinfo["ID"] = photoModel.id
        displayinfo["Title"] = photoModel.title.content
        displayinfo["Owner"] = photoModel.owner.realname
        displayinfo["Uploaded Date"] = photoModel.dateuploaded.convertToDisplayDate()
        displayinfo["Taken Date"] = photoModel.dates.taken
        displayinfo["Views"] = photoModel.views
        displayinfo["Tags"] = photoModel.tags.tag.map{ $0.raw}.joined(separator: ", ")
        return displayinfo
    }
    
    private func appendExifInfo() {
        guard let photoExifModel = photoExifModel else { return }
        
        photoExifModel.exif.forEach { exif in
            displayDictionary[exif.label] = exif.raw.content
        }
        displayDictionary["Camera"] = photoExifModel.camera
    }
    
    /// Possibly find all different icon for match key values
    private func image(for key:String, value: String) -> Image? {
        var image:Image? = nil
        
        if key == "Aperture" {
            image = Image(systemName: "camera.aperture")
        } else if key == "Camera"{
            image = Image(systemName: "camera.circle")
        } else if key == "Color space"{
            image = Image(systemName: "camera.filters")
        } else if key == "Flash" {
            if value .contains("not") {
                image = Image(systemName: "bolt.slash.fill")
            } else {
                image = Image(systemName: "bolt.fill")
            }
        }
        return image
    }
}

struct PhotoMetaDataView_Previews: PreviewProvider {
    static var previews: some View {
        let photoModel = Bundle.main.decode(PhotoResponse.self, from: "DummyPhotoModel.json").photo
        PhotoMetaDataView(photoModel: photoModel)
    }
}

