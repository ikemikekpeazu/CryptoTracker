//
//  XMarkButton.swift
//  SwiftfulCrypto
//
//  Created by Ikem Ikekpeazu on 3/24/26.
//


// NOT USED IN APP


import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    XMarkButton()
}
