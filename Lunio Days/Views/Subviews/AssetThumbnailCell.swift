//
//  AssetThumbnailCell.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI
import Photos

struct AssetThumbnailCell: View {

    let asset: PHAsset
    let side: CGFloat

    @State private var image: UIImage?
    @State private var requestID: PHImageRequestID = PHInvalidImageRequestID

    private let manager = PHCachingImageManager.default()

    var body: some View {
        ZStack {
            Color.black.opacity(0.06)

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .frame(width: side, height: side)
        .clipped()
        .onAppear {
            requestThumbnail()
        }
        .onDisappear { cancelRequest() }
    }

    private func requestThumbnail() {
        cancelRequest()

        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: side * scale, height: side * scale)

        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isSynchronous = false

        requestID = manager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { img, _ in
            self.image = img
        }
    }

    private func cancelRequest() {
        if requestID != PHInvalidImageRequestID {
            manager.cancelImageRequest(requestID)
            requestID = PHInvalidImageRequestID
        }
    }
}
