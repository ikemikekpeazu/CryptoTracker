//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Ikem Ikekpeazu on 3/23/26.
//

import Foundation
import SwiftUI


extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
