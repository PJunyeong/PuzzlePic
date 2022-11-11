//
//  PhotoModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

struct PhotoModel: Hashable, Codable {
    var photoId: String = UUID().uuidString
    let photoURL: URL?
    let row: Int
    let column: Int
    let createdUserId: String
    func hash(into hasher: inout Hasher) {
        hasher.combine(photoId)
    }
}
