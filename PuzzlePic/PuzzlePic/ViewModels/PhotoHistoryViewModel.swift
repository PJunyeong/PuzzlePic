//
//  PhotoHistoryViewModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import Combine

class PhotoHistoryViewModel {
    let userPhotoRooms: CurrentValueSubject<[PhotoRoomModel], Never> = .init([])
    private let dataService = FirestoreManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
}
