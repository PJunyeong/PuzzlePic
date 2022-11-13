//
//  PhotoRoomViewModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/12.
//

import Foundation
import Combine
import UIKit

class PhotoRoomViewModel {
//    let model: PhotoRoomModel
//    let photoRoomModel: PassthroughSubject<PhotoRoomModel, Never> = .init()
//    let photoModels: CurrentValueSubject<[PhotoModel], Never> = .init([])
//    private let sortedPhotoModels: CurrentValueSubject<[PhotoModel], Never> = .init([])
//    private var dataSource: UICollectionViewDiffableDataSource<PhotoCollectionViewSection, PhotoModel>!
//    private let dataService: PhotoRoomDataManager
//    private var cancellables = Set<AnyCancellable>()
//
//    init(model: PhotoRoomModel) {
//        self.model = model
//        self.dataService = PhotoRoomDataManager(photoRoomId: model.photoRoomId)
//        addSubscription(model: model)
//    }
//
//    private func updateDateSource(items: [PhotoModel]) {
//        var snapshot = NSDiffableDataSourceSnapshot<PhotoCollectionViewSection, PhotoModel>()
//        snapshot.appendSections(PhotoCollectionViewSection.allCases)
//        snapshot.appendItems(items)
//        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
//    }
//
//    func addSubscription(model: PhotoRoomModel) {
//        dataService
//            .photoRoom
//            .sink { [weak self] photoRoom in
//                guard let photoRoom = photoRoom else { return }
//                self?.photoRoomModel.send(photoRoom)
//            }
//            .store(in: &cancellables)
//        photoRoomModel
//            .sink { [weak self] room in
//                self?.fetchPhotoModels(photoIds: room.photoIds)
//            }
//            .store(in: &cancellables)
//    }
//
//    func bind(collectionView: UICollectionView) {
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
//            guard
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return nil }
//            return cell
//        })
//        photoModels
//            .map(sortAndAddModels)
//            .sink { [weak self] items in
//                self?.sortedPhotoModels.send(items)
//                self?.updateDateSource(items: items)
//            }
//            .store(in: &cancellables)
//    }
//
//    private func sortAndAddModels(models: [PhotoModel]) -> [PhotoModel] {
//        let sideCount = model.sideCount
//        let userId = UserDefaultsManager.userId
//        let totalCount = sideCount * sideCount
//        var items:[PhotoModel] = []
//        let models = models.sorted(by: {$0.currentPostion < $1.currentPostion})
//        var currentIndex = 0
//        for model in models {
//            if currentIndex == model.currentPostion {
//                items.append(model)
//                currentIndex += 1
//            } else {
//                while model.currentPostion < currentIndex {
//                    let row = currentIndex / sideCount
//                    let col = currentIndex % sideCount
//                    let photoModel = PhotoModel(photoRoomId: model.photoRoomId, photoURL: nil, row: row, column: col, sideCount: sideCount, createdUserId: userId)
//                    items.append(photoModel)
//                    currentIndex += 1
//                }
//            }
//        }
//        while currentIndex < totalCount {
//            let row = currentIndex / sideCount
//            let col = currentIndex % sideCount
//            let photoModel = PhotoModel(photoRoomId: model.photoRoomId, photoURL: nil, row: row, column: col, sideCount: sideCount, createdUserId: userId)
//            items.append(photoModel)
//            currentIndex += 1
//        }
//        return items
//    }
//
//    private func fetchPhotoModels(photoIds: [String]) {
//        photoIds.forEach({ photoId in
//            fetchPhotoModel(photoId: photoId)
//        })
//    }
//
//    private func fetchPhotoModel(photoId: String) {
//        let dataService = PhotoModelDataManager(photoId: photoId)
//        dataService
//            .photoModel
//            .sink { [weak self] photoModel in
//                guard let photoModel = photoModel else { return }
//                let currentModels = self?.photoModels.value ?? []
//                let newModels = currentModels + [photoModel]
//                self?.photoModels.send(newModels)
//            }
//            .store(in: &cancellables)
//    }
}
