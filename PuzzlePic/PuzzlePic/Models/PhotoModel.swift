//
//  PhotoModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

struct PhotoModel: Hashable {
    let photoId: String = UUID().uuidString
    let photoURL: URL?
    let row: Int
    let column: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(photoId)
    }
}
