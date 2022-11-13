//
//  PhotoModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

struct PhotoModel: Hashable, Codable {
    var photoId: String = UUID().uuidString
    let photoRoomId: String
    let photoURL: URL?
    let row: Int
    let column: Int
    let sideCount: Int
    let createdUserId: String
    var rotatation: Int
    var isMirrored: Bool
    var isValid: Bool
    func hash(into hasher: inout Hasher) {
        hasher.combine(photoId)
    }
    var currentPostion: Int {
        return row * sideCount + column
    }
}
