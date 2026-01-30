//
//  AvatarPickerViewModel.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import Photos
import Combine

final class AvatarPickerViewModel: ObservableObject {

    @Published private(set) var status: PHAuthorizationStatus
    @Published private(set) var assets: [PHAsset] = []

    private let columnsCount: Int

    init(
        columnsCount: Int = 3,
        initialStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    ) {
        self.columnsCount = columnsCount
        self.status = initialStatus
    }

    func onAppear() {
        refreshStatusAndLoad()
        if status == .notDetermined {
            requestAuthorization()
        }
    }

    func refreshStatusAndLoad() {
        status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            loadAssets()
        }
    }

    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
            DispatchQueue.main.async {
                guard let self else { return }
                self.status = newStatus
                if newStatus == .authorized || newStatus == .limited {
                    self.loadAssets()
                }
            }
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    func cellSize(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let columns = CGFloat(columnsCount)
        return (width - spacing * (columns - 1) - 4) / columns
    }

    func pickImage(from asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 1400, height: 1400),
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            completion(image)
        }
    }

    // MARK: - Private method
    private func loadAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        var temp: [PHAsset] = []
        temp.reserveCapacity(result.count)

        result.enumerateObjects { asset, _, _ in
            temp.append(asset)
        }

        assets = temp
    }
}
