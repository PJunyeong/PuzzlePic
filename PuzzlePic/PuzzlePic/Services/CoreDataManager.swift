//
//  CoredataManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import CoreData
import Combine

class CoreDataManager {
    private let container: NSPersistentContainer
    private let containerName = "PhotoDataContainer"
    private let photoRoomEntityName = "PhotoRoomEntity"
    let photoRoomEntities: CurrentValueSubject<[PhotoRoomEntity], Never> = .init([])
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            self?.fetchPhotoRoomEntities()
        }
    }
    
    func updateData(photoRoomModel: PhotoRoomModel) {
        if let entity = photoRoomEntities.value.first(where: { $0.photoRoomId == photoRoomModel.photoRoomId }) {
            update(entity: entity, photoRoomModel: photoRoomModel)
        } else {
            add(photoRoomModel: photoRoomModel)
        }
    }
    
    func deleteData(photoRoomModel: PhotoRoomModel) {
        if let entity = photoRoomEntities.value.first(where: { $0.photoRoomId == photoRoomModel.photoRoomId }) {
            delete(entity: entity)
        }
    }
    
    private func fetchPhotoRoomEntities() {
        let request = NSFetchRequest<PhotoRoomEntity>(entityName: photoRoomEntityName)
        do {
            let data = try container.viewContext.fetch(request)
            photoRoomEntities.send(data)
        } catch {
            print(error.localizedDescription)
        }
    }
        
    private func add(photoRoomModel: PhotoRoomModel) {
        let entity = PhotoRoomEntity(context: container.viewContext)
        entity.photoRoomId = photoRoomModel.photoRoomId
        entity.createdDate = photoRoomModel.createdDate
        entity.createdUserId = photoRoomModel.createdUserId
        entity.isCompleted = photoRoomModel.isCompleted
        entity.password = photoRoomModel.password
        entity.title = photoRoomModel.title
        entity.photoTemplate = photoRoomModel.photoTemplate
        entity.sideCount = Int64(photoRoomModel.sideCount)
        entity.photoModels = photoRoomModel.photoModels.compactMap({ model -> PhotoEntity in
            let entity = PhotoEntity(context: container.viewContext)
            entity.photoId = model.photoId
            entity.column = Int64(model.column)
            entity.row = Int64(model.row)
            if let photoURLString = model.photoURL?.absoluteString {
                entity.photoURLString = photoURLString
            }
            return entity
        })
        if let linkURLString = photoRoomModel.linkURL?.absoluteString {
            entity.linkURLString = linkURLString
        }
        if let completedThumbnailURLString = photoRoomModel.photoRoomCompletedThumbnailURL?.absoluteString {
            entity.photoRoomCompletedThumbnailURL = completedThumbnailURLString
        }
        if let thumbnailURLString = photoRoomModel.photoRoomThumbnailURL?.absoluteString {
            entity.photoRoomThumbnailURLString = thumbnailURLString
        }
        applyChange()
    }
    
    private func update(entity: PhotoRoomEntity, photoRoomModel: PhotoRoomModel) {
        entity.photoRoomId = photoRoomModel.photoRoomId
        entity.title = photoRoomModel.title
        entity.createdUserId = photoRoomModel.createdUserId
        entity.password = photoRoomModel.password
        entity.isCompleted = photoRoomModel.isCompleted
        entity.createdDate = photoRoomModel.createdDate
        entity.photoTemplate = photoRoomModel.photoTemplate
        entity.sideCount = Int64(photoRoomModel.sideCount)
        entity.photoModels = photoRoomModel.photoModels.compactMap({ model -> PhotoEntity in
            let entity = PhotoEntity(context: container.viewContext)
            entity.photoId = model.photoId
            entity.column = Int64(model.column)
            entity.row = Int64(model.row)
            if let photoURLString = model.photoURL?.absoluteString {
                entity.photoURLString = photoURLString
            }
            return entity
        })
        if let photoRoomThumbnailURLString = photoRoomModel.photoRoomThumbnailURL?.absoluteString {
            entity.photoRoomThumbnailURLString = photoRoomThumbnailURLString
        }
        if let photoRoomCompletedThumbnailURLString = photoRoomModel.photoRoomCompletedThumbnailURL?.absoluteString {
            entity.photoRoomCompletedThumbnailURL = photoRoomCompletedThumbnailURLString
        }
        if let linkURLString = photoRoomModel.linkURL?.absoluteString {
            entity.linkURLString = linkURLString
        }
        applyChange()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func delete(entity: PhotoRoomEntity) {
        container.viewContext.delete(entity)
        applyChange()
    }
    
    private func applyChange() {
        save()
    }
}
