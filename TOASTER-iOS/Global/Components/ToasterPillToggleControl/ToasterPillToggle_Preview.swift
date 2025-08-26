//
//  ToasterPillToggle_Preview.swift
//  TOASTER-iOS
//
//  Created by mini on 8/25/25.
//

import SwiftUI

struct ToasterPillTogglePreview: UIViewRepresentable {
    func makeUIView(context: Context) -> ToasterPillToggleControl {
        let v = ToasterPillToggleControl()
        return v
    }
    func updateUIView(_ uiView: ToasterPillToggleControl, context: Context) {}
}

#Preview {
    ToasterPillTogglePreview()
        .frame(width: 260, height: 56)
        .padding()
}
