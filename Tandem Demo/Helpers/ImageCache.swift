//
//  ImageCache.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 09.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    static let sharedCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        cache.countLimit = 20
        cache.totalCostLimit = 10*1024*1024
        return cache
    }()
}
