//
//  PhotoRoomModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

struct PhotoRoomModel {
    let photoRoomId: String = UUID().uuidString
    var title: String
    let createdUserName: String
    let createdDate: String
    let photoTemplate: String
    let sideCount: Int
    var photoURLs: [PhotoModel]
}
