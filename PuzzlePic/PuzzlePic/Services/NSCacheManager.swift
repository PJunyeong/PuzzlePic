//
//  NSCacheManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import UIKit

class NSCacheManager {
    static let shared = NSCacheManager()
    private init() {}
    
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 1024
        return cache
    }()
    
    func get(name: String) -> UIImage? {
        guard let image = imageCache.object(forKey: name as NSString) else { return nil }
        return image
    }
    
    func save(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    func remove(with name: String) {
        imageCache.removeObject(forKey: name as NSString)
    }
}
