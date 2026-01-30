//
//  AvatarPickerSheet.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI
import Photos


struct AvatarPickerSheet: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm = AvatarPickerViewModel()

    let onPick: (UIImage) -> Void

    private let spacing: CGFloat = 2
    private let columnsCount: Int = 3

    var body: some View {
        NavigationView {
            Group {
                switch vm.status {
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
                vm.onAppear()
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
                vm.openSettings()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }

    private var gridView: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let cellSide = vm.cellSize(for: width, spacing: spacing)

            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(cellSide), spacing: spacing), count: columnsCount),
                    spacing: spacing
                ) {
                    ForEach(vm.assets, id: \.localIdentifier) { asset in
                        AssetThumbnailCell(asset: asset, side: cellSide)
                            .onTapGesture {
                                vm.pickImage(from: asset) { image in
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
}
