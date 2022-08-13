//
//  PhotoPicker.swift
//  MediaUploader
//
//  Created by Apekshik Panigrahi on 8/13/22.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Select a photo")
            }
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
                .frame(width: 250, height: 250)
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker()
    }
}
