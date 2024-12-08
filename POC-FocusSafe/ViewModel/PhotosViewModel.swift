//
//  PhotosViewModel.swift
//  POC-FocusSave
//
//  Created by Victor Manuel Blanco Mancera on 25/10/24.
//

import Foundation
import Photos

class PhotosViewModel: ObservableObject {
    @Published var photos: [PHAsset] = []
    @Published var permissionDenied = false

    func requestPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.loadPhotos()
                case .denied, .restricted:
                    self.permissionDenied = true
                default:
                    break
                }
            }
        }
    }

    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        allPhotos.enumerateObjects { asset, _, _ in
            self.photos.append(asset)
        }
    }
}
