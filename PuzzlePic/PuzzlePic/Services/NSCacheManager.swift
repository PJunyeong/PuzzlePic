//
//  NSCacheManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

class NSCacheManager {
    static let shared = NSCacheManager()
    private init() {}
    
    func get(with url: URL) -> Data? {
        return nil
    }
    
    func save(with data: Data) {
        
    }
}
