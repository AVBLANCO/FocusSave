//
//  PhotosView.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import SwiftUI
import PhotosUI

struct PhotosView: View {
    @StateObject private var viewModel = PhotosViewModel()

    var body: some View {
        VStack {
            if viewModel.permissionDenied {
                Text("Permiso para acceder a fotos denegado.")
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(viewModel.photos, id: \.self) { asset in
                            if let image = UIImage.getThumbnail(for: asset) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8) // Opcional: para un diseño más suave
                                    .clipped() // Opcional: para recortar los bordes
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.requestPermission()
                }
            }
        }
        .navigationTitle("Fotos")
    }
}

extension UIImage {
    static func getThumbnail(for asset: PHAsset, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true // Carga sincrónica
        options.deliveryMode = .highQualityFormat

        var thumbnail: UIImage?

        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { (result, _) in
            if let result = result {
                thumbnail = result
            }
        }

        return thumbnail
    }
}
