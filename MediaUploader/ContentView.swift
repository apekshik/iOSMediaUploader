//
//  ContentView.swift
//  MediaUploader
//
//  Created by Apekshik Panigrahi on 8/13/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            PhotoPicker()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
