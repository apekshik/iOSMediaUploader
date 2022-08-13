//
//  PhotoPickerV2.swift
//  MediaUploader
//
//  Created by Apekshik Panigrahi on 8/13/22.
//
// Same as PhotoPicker, but with the photo draggable around the screen.
// link to tutorial for smooth drag: https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/

import SwiftUI
import PhotosUI

struct PhotoPickerV2: View {

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    // here we use the location variable to keep track of draggable image.
    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil // 1
     
    var simpleDrag: some Gesture {
         DragGesture()
             .onChanged { value in
                 var newLocation = startLocation ?? location // 3
                 newLocation.x += value.translation.width
                 newLocation.y += value.translation.height
                 self.location = newLocation
             }.updating($startLocation) { (value, startLocation, transaction) in
                 startLocation = startLocation ?? location // 2
             }
    }
     
    var fingerDrag: some Gesture {
         DragGesture()
             .updating($fingerLocation) { (value, fingerLocation, transaction) in
                 fingerLocation = value.location
             }
    }
        
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(40)
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrive selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            if let selectedImageData,
               let image = UIImage(data: selectedImageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .cornerRadius(20)
                    .position(location)
                    .gesture( simpleDrag.simultaneously(with: fingerDrag) )
            }
        }
        
    }
}

struct PhotoPickerV2_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerV2()
    }
}
