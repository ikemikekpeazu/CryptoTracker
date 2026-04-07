//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Ikem Ikekpeazu on 3/27/26.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    
}
