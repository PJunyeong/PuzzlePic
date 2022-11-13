//
//  FirestoreManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import FirebaseFirestore
import Combine

class PhotoRoomsSearchDataManager {
    private let database = Firestore.firestore()
    let allPhotoRoomSearchs: CurrentValueSubject<[PhotoRoomSearchModel], Never> = .init([])
    let userPhotoRoomSearchs: CurrentValueSubject<[PhotoRoomSearchModel], Never> = .init([])
    private let photoRoomSearchCollectionPath = "photo_room_search_path"
    private var cancellables = Set<AnyCancellable>()
    private var observer: ListenerRegistration?
    
    init() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.addObserver()
            self?.bind()
        }
    }
    
    deinit {
        removeObserver()
    }
    
    func set(photoRoomModel: PhotoRoomModel) {
        guard let documentData = photoRoomModel.dictionary else { return }
        database
            .collection(photoRoomSearchCollectionPath)
            .document(photoRoomModel.photoRoomId)
            .setData(documentData, merge: true)
    }
    
    func delete(photoRoomModel: PhotoRoomModel) {
        database
            .collection(photoRoomSearchCollectionPath)
            .document(photoRoomModel.photoRoomId)
            .delete()
    }
    
    private func addObserver() {
        observer = database
            .collection(photoRoomSearchCollectionPath)
            .addSnapshotListener { [weak self] snapshot, error in
                guard
                    let documents = snapshot?.documents,
                    error == nil else { return }
                let allPhotoRoomSearchs = documents
                    .map({ $0.data() })
                    .compactMap { data -> PhotoRoomSearchModel? in
                        if let photoRoomSearchModel: PhotoRoomSearchModel = try? PhotoRoomSearchModel.decode(dictionary: data) {
                            return photoRoomSearchModel
                        } else {
                            return nil
                        }
                    }
                self?.allPhotoRoomSearchs.send(allPhotoRoomSearchs)
            }
    }
    
    private func removeObserver() {
        observer = nil
    }
    
    private func bind() {
        allPhotoRoomSearchs
            .map(filterUsersPhotoRooms)
            .sink { [weak self] rooms in
                self?.userPhotoRoomSearchs.send(rooms)
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortPhotoRooms(rooms: [PhotoRoomSearchModel]) -> [PhotoRoomSearchModel] {
        let filteredRooms = filterUsersPhotoRooms(rooms: rooms)
        let sortedRooms = sortPhotoRooms(rooms: filteredRooms)
        return sortedRooms
    }
    
    private func sortPhotoRooms(rooms: [PhotoRoomSearchModel]) -> [PhotoRoomSearchModel] {
        return rooms.sorted { first, second in
            guard
                let firstDate = first.createdDate.asDate,
                let secondDate = second.createdDate.asDate else { fatalError() }
            return firstDate > secondDate
        }
    }
    
    private func filterUsersPhotoRooms(rooms: [PhotoRoomSearchModel]) -> [PhotoRoomSearchModel] {
        let userId = UserDefaultsManager.userId
        return rooms.filter({$0.joinedUserIds.contains(userId)})
    }
}
