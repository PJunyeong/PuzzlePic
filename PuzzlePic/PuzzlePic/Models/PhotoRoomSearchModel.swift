//
//  PhotoRoomSearchModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/13.
//

import Foundation

struct PhotoRoomSearchModel: Hashable, Codable {
    var photoRoomId: String
    var photoRoomThumbnailURL: URL?
    var title: String
    let createdUserId: String
    let password: String
    var isCompleted: Bool
    let createdDate: String
    var joinedUserIds: [String]
    func hash(into hasher: inout Hasher) {
        hasher.combine(photoRoomId)
    }
}
