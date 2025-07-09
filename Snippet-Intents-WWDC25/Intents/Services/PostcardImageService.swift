//
//  PostcardImageService.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import Foundation
import SwiftUI


class PostcardImageService: @unchecked Sendable {

    private var cachedSampleImages: [Data] = []
    
    init() {
        let images: [UIImage] = [
            .img1, .img2, .img3, .img4
        ]
        cachedSampleImages = images.compactMap{ $0.pngData() }
    }
    
    func getRandomImage() -> Data? {
        return cachedSampleImages.randomElement()
    }

} 
