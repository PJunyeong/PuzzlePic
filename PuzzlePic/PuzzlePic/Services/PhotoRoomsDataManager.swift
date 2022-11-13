//
//  FirestoreManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import FirebaseFirestore
import Combine

class PhotoRoomsDataManager {
    private let database = Firestore.firestore()
    let allPhotoRoomSearchs: CurrentValueSubject<[PhotoRoomSearchModel], Never> = .init([])
    let userPhotoRoomSearchs: CurrentValueSubject<[PhotoRoomSearchModel], Never> = .init([])
    var photoRoom: CurrentValueSubject<PhotoRoomModel?, Never> = .init(nil)
    private let photoRoomSearchCollectionPath = "photo_room_search_path"
    private let photoRoomCollectionPath = "photo_room_path"
    private var cancellables = Set<AnyCancellable>()
    private var searchObserver: ListenerRegistration?
    private var roomObserver: ListenerRegistration?
    
    init() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.addSearchObserver()
            self?.bind()
        }
    }
    
    deinit {
        removeObservers()
    }
    
    func set(photoRoomModel: PhotoRoomModel) {
        guard let documentData = photoRoomModel.dictionary else { return }
        database
            .collection(photoRoomCollectionPath)
            .document(photoRoomModel.photoRoomId)
            .setData(documentData, merge: true)
    }
    
    func set(photoRoomSearchModel: PhotoRoomSearchModel) {
        guard let documentData = photoRoomSearchModel.dictionary else { return }
        database
            .collection(photoRoomSearchCollectionPath)
            .document(photoRoomSearchModel.photoRoomId)
            .setData(documentData, merge: true)
    }
    
    func delete(photoRoomModel: PhotoRoomModel) {
        database
            .collection(photoRoomCollectionPath)
            .document(photoRoomModel.photoRoomId)
            .delete()
    }
    
    func delete(photoRoomSearchModel: PhotoRoomSearchModel) {
        database
            .collection(photoRoomSearchCollectionPath)
            .document(photoRoomSearchModel.photoRoomId)
            .delete()
    }
    
    func addRoomObserver(model: PhotoRoomSearchModel) {
        photoRoom = .init(nil)
        roomObserver = database
            .collection(photoRoomCollectionPath)
            .document(model.photoRoomId)
            .addSnapshotListener({ [weak self] snapshot, error in
                if
                    let document = snapshot?.data(),
                    let room: PhotoRoomModel = try? PhotoRoomModel.decode(dictionary: document) {
                    self?.photoRoom.send(room)
                } else {
                    self?.photoRoom.send(nil)
                }
            })
    }
    
    private func addSearchObserver() {
        searchObserver = database
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
    
    private func removeObservers() {
        removeSearchObserver()
        removeRoomObserver()
    }
    
    func removeRoomObserver() {
        roomObserver = nil
        photoRoom.send(completion: .finished)
    }
    
    private func removeSearchObserver() {
        searchObserver = nil
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
