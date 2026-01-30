//
//  CameraPicker.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 28.01.2026.
//

import SwiftUI
import UIKit

struct CameraPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode

    let onPick: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick, presentationMode: presentationMode)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        let onPick: (UIImage) -> Void
        let presentationMode: Binding<PresentationMode>

        init(onPick: @escaping (UIImage) -> Void, presentationMode: Binding<PresentationMode>) {
            self.onPick = onPick
            self.presentationMode = presentationMode
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.wrappedValue.dismiss()
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let edited = info[.editedImage] as? UIImage {
                onPick(edited)
            } else if let original = info[.originalImage] as? UIImage {
                onPick(original)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}
