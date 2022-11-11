//
//  FirestoreManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import FirebaseFirestore
import Combine

class FirestoreManager {
    static let shared = FirestoreManager()
    private let database = Firestore.firestore()
    let allPhotoRooms: CurrentValueSubject<[PhotoRoomModel], Never> = .init([])
    let userPhotoRooms: CurrentValueSubject<[PhotoRoomModel], Never> = .init([])
    private let photoCollectionPath = "photo_collection_path"
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
            .collection(photoCollectionPath)
            .document(photoRoomModel.photoRoomId)
            .setData(documentData, merge: true)
    }
    
    func delete(photoRoomModel: PhotoRoomModel) {
        database
            .collection(photoCollectionPath)
            .document(photoRoomModel.photoRoomId)
            .delete()
    }
    
    private func addObserver() {
        observer = database
            .collection(photoCollectionPath)
            .addSnapshotListener { [weak self] snapshot, error in
                guard
                    let documents = snapshot?.documents,
                    error == nil else { return }
                let allPhotoRooms = documents
                    .map({ $0.data() })
                    .compactMap { data -> PhotoRoomModel? in
                        if let photoRoomModel: PhotoRoomModel = try? PhotoRoomModel.decode(dictionary: data) {
                            return photoRoomModel
                        } else {
                            return nil
                        }
                    }
                self?.allPhotoRooms.send(allPhotoRooms)
            }
    }
    
    private func removeObserver() {
        observer = nil
    }
    
    private func bind() {
        allPhotoRooms
            .map(filterUsersPhotoRooms)
            .sink { [weak self] rooms in
                self?.userPhotoRooms.send(rooms)
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortPhotoRooms(rooms: [PhotoRoomModel]) -> [PhotoRoomModel] {
        let filteredRooms = filterUsersPhotoRooms(rooms: rooms)
        let sortedRooms = sortPhotoRooms(rooms: filteredRooms)
        return sortedRooms
    }
    
    private func sortPhotoRooms(rooms: [PhotoRoomModel]) -> [PhotoRoomModel] {
        return rooms.sorted { first, second in
            guard
                let firstDate = first.createdDate.asDate,
                let secondDate = second.createdDate.asDate else { fatalError() }
            return firstDate > secondDate
        }
    }
    
    private func filterUsersPhotoRooms(rooms: [PhotoRoomModel]) -> [PhotoRoomModel] {
        let userId = UserDefaultsManager.userId
        return rooms.filter({$0.joinedUserIds.contains(userId)})
    }
}
