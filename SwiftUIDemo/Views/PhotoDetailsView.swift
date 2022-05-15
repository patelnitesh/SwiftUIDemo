//
//  PhotoDetailsView.swift
//  SwiftUIDemo
//
//  Created by Nitesh Patel on 28/04/2022.
//

import SwiftUI

struct PhotoDetailsView: View {
    let flickrPhotos: [FlickrPhoto]
    let picID: String
    @State private var selectedId: String = ""
    @State private var isShowingDetailView = false
    @State private var photoModel: PhotoModel!
    @State private var showError = false
    @State var scale: CGFloat = 1.0

    
    var body: some View {
        if let photoModel = photoModel {
            NavigationLink(destination: PhotoMetaDataView(photoModel: photoModel), isActive: $isShowingDetailView) { EmptyView() }
        }
        TabView(selection: $selectedId) {
                ForEach(flickrPhotos, id: \.id) { flickrPhoto in
                        AsyncImageView(url: flickrPhoto.imageURL)
                            .frame(width: UIScreen.main.bounds.width, alignment: .center)
                            .tag(flickrPhoto.id)
                            .scaleEffect(scale)
                            .scaledToFit()
                            .gesture(MagnificationGesture()
                                .onChanged{value in
                                    self.scale = value.magnitude
                                }
                            ).gesture(TapGesture(count: 2).onEnded{
                                if(self.scale <= 2.0){
                                    self.scale = self.scale * 2
                                } else if(self.scale >= 2.0){
                                    self.scale = 1.0
                                }
                            })
                            .animation(.spring(response: 1.5), value: selectedId)
                }
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text("Can not load photo information. Please try again or choose another picture."), dismissButton: .default(Text("Okay")))
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
        .onAppear(){
            selectedId = picID
        }
        .onChange(of: selectedId) { newValue in
            self.scale = 1.0
        }
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    getPhotoInformation()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
    }
    
    private func getPhotoInformation(){
        Task{
            await loadPhotoModel()
        }
    }
    
    private func loadPhotoModel() async {
        do {
            photoModel = try await ApiClient().loadPhoto(photoId: selectedId)
            isShowingDetailView = true
        } catch {
            print("Error loading")
            showError = true
        }
    }
}

struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let flickrPhotos = [FlickrPhoto(id: "52036487932", photoModel: nil, photoExif: nil, imageURL: "https://live.staticflickr.com/65535/52036487932_e24a6f86bc_m.jpg"), FlickrPhoto(id: "52036488072", photoModel: nil, photoExif: nil, imageURL: "https://live.staticflickr.com/65535/52036488072_4e0eaf2693_m.jpg"), FlickrPhoto(id: "52036488102", photoModel: nil, photoExif: nil, imageURL: "https://live.staticflickr.com/65535/52036488102_9d11ef9543_m.jpg")]
        PhotoDetailsView(flickrPhotos: flickrPhotos, picID: "52036488072")
    }
}
