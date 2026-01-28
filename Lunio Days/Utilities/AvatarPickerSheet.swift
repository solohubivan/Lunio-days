//
//  AvatarPickerSheet.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI
import Photos

struct AvatarPickerSheet: View {

    let onPick: (UIImage) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    @State private var assets: [PHAsset] = []

    private let spacing: CGFloat = 2
    private let columnsCount: Int = 3

    var body: some View {
        NavigationView {
            Group {
                switch status {
                case .authorized, .limited:
                    gridView
                case .notDetermined:
                    requestingView
                case .denied, .restricted:
                    deniedView
                @unknown default:
                    deniedView
                }
            }
            .navigationBarTitle("Choose photo", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") { dismiss() })
            .onAppear {
                refreshStatusAndLoad()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Views

    private var requestingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Requesting access to Photos...")
                .font(.phetsarath(.regular, size: 14))
                .foregroundColor(.brownText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .task {
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            await MainActor.run {
                status = newStatus
                if newStatus == .authorized || newStatus == .limited {
                    loadAssets()
                }
            }
        }
    }

    private var deniedView: some View {
        VStack(spacing: 16) {
            Text("Photos access is disabled")
                .font(.phetsarath(.bold, size: 18))
                .foregroundColor(.brownText)

            Text("Allow access in Settings to choose an avatar from your library.")
                .font(.phetsarath(.regular, size: 14))
                .foregroundColor(.brownText.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }

    private var gridView: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let cellSide = cellSize(for: width)

            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(cellSide), spacing: spacing), count: columnsCount),
                    spacing: spacing
                ) {
                    ForEach(assets, id: \.localIdentifier) { asset in
                        AssetThumbnailCell(asset: asset, side: cellSide)
                            .onTapGesture {
                                loadFullImage(asset: asset) { image in
                                    guard let image else { return }
                                    onPick(image)
                                    dismiss()
                                }
                            }
                    }
                }
                .padding(2)
            }
            .background(Color.white.ignoresSafeArea())
        }
    }

    // MARK: - private helpers

    private func cellSize(for width: CGFloat) -> CGFloat {
        let columns = CGFloat(columnsCount)
        return (width - spacing * (columns - 1) - 4) / columns
    }

    private func refreshStatusAndLoad() {
        status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            loadAssets()
        }
    }

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

    private func loadFullImage(asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
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
}
