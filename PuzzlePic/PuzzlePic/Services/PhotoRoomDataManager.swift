//
//  PhotoRoomDataManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/12.
//

import Foundation
import FirebaseFirestore
import Combine

class PhotoRoomDataManager {
    private let database = Firestore.firestore()
    let photoRoom: CurrentValueSubject<PhotoRoomModel?, Never> = .init(nil)
    private let photoRoomCollectionPath = "photo_room_path"
    private var cancellables = Set<AnyCancellable>()
    private var observer: ListenerRegistration?
    
    init(photoRoomId: String) {
        addObserver(photoRoomId: photoRoomId)
    }
    
    deinit {
        removeObserver()
    }
    
    private func removeObserver() {
        observer = nil
    }
    
    private func addObserver(photoRoomId: String) {
        observer = database
            .collection(photoRoomCollectionPath)
            .document(photoRoomId)
            .addSnapshotListener { [weak self] snapshot, error in
                if
                    let data = snapshot?.data(),
                    let photoRoomModel: PhotoRoomModel = try? PhotoRoomModel.decode(dictionary: data) {
                    self?.photoRoom.send(photoRoomModel)
                } else {
                    self?.photoRoom.send(nil)
                }
            }
    }
}
