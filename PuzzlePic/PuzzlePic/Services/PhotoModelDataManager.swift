//
//  PhotoModelDataManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/12.
//

import Foundation
import Combine
import FirebaseFirestore

class PhotoModelDataManager {
    private let database = Firestore.firestore()
    let photoModel: CurrentValueSubject<PhotoModel?, Never> = .init(nil)
    private let photoModelCollectionPath = "photo_model_collection_path"
    private var observer: ListenerRegistration?
    
    init(photoId: String) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.addObserver(photoId: photoId)
        }
    }
    
    deinit {
        removeObserver()
    }
    
    private func addObserver(photoId: String) {
        observer = database
            .collection(photoModelCollectionPath)
            .document(photoId)
            .addSnapshotListener { [weak self] snapshot, error in
                if
                    let data = snapshot?.data(),
                    let photoModel:PhotoModel = try? PhotoModel.decode(dictionary: data) {
                    self?.photoModel.send(photoModel)
                } else {
                    self?.photoModel.send(nil)
                }
            }
    }
    
    private func removeObserver() {
        observer = nil
    }
}
