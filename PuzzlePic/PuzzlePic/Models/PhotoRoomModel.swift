//
//  PhotoRoomModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

struct PhotoRoomModel: Hashable {
    let photoRoomId: String = UUID().uuidString
    var photoRoomThumnailURL: URL?
    var photoRoomCompletedThumnailURL: URL?
    var title: String
    let createdUserId: String
    let password: String
    var isCompleted: Bool = false
    var linkURL: URL?
    let createdDate: String
    let photoTemplate: String
    let sideCount: Int
    var photoURLs: [PhotoModel]
    func hash(into hasher: inout Hasher) {
        hasher.combine(photoRoomId)
    }
}
