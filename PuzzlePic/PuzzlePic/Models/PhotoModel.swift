//
//  PhotoModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

struct PhotoModel {
    let photoId: String = UUID().uuidString
    let photoURL: URL?
    let row: Int
    let column: Int
}
