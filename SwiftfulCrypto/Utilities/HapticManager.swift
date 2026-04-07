//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by Ikem Ikekpeazu on 3/25/26.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
