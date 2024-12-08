////
////  FamilyActivityPickerView.swift
////  POC-FocusSave
////
////  Created by Victor Manuel Blanco Mancera on 6/11/24.
////
//
//import SwiftUI
//import FamilyControls
//
//struct FamilyActivityPickerView: UIViewControllerRepresentable {
//    @Binding var selectedApps: FamilyActivitySelection
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let picker = FamilyActivityPicker()
//        picker.selection = selectedApps
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if let picker = uiViewController as? FamilyActivityPicker {
//            picker.selection = selectedApps
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, FamilyActivityPickerDelegate {
//        var parent: FamilyActivityPickerView
//
//        init(_ parent: FamilyActivityPickerView) {
//            self.parent = parent
//        }
//
//        func familyActivityPicker(_ picker: FamilyActivityPicker, didSelect selection: FamilyActivitySelection) {
//            parent.selectedApps = selection
//        }
//    }
//}
