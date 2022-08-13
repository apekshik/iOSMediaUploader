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
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
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
                    .frame(width: 250)
                    .cornerRadius(20)
                    .rotation3DEffect(.degrees(4), axis: (x: 0, y: 1, z: 0))
                    .offset(x: offset.width, y: 0)
                    .opacity(2 - Double(abs(offset.width / 50)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                if abs(offset.width) > 200 {
                                    // remove the card
                                } else {
                                    offset = .zero
                                }
                            }
                    )
            }
        }
        
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker()
    }
}
