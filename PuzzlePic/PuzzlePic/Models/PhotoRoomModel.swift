//
//  PhotoRoomModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

struct PhotoRoomModel: Hashable, Codable {
    var photoRoomId: String = UUID().uuidString
    var photoRoomThumbnailURL: URL?
    var photoRoomCompletedThumbnailURL: URL?
    var title: String
    let createdUserId: String
    let password: String
    var isCompleted: Bool = false
    var linkURL: URL?
    let createdDate: String
    let photoTemplate: String
    let sideCount: Int
    var photoModels: [PhotoModel]
    var lastUpdatedDate: String
    var joinedUserIds: [String]
    func hash(into hasher: inout Hasher) {
        hasher.combine(photoRoomId)
    }
}
