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
    let model: PhotoRoomSearchModel
    private var dataSource: UICollectionViewDiffableDataSource<PhotoCollectionViewSection, PhotoModel>!
    private let sortedPhotoModels: CurrentValueSubject<[PhotoModel], Never> = .init([])
    private var dataService: PhotoRoomsDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(model: PhotoRoomSearchModel, dataService: PhotoRoomsDataManager) {
        self.model = model
        self.dataService = dataService
    }
    
    deinit {
        dataService.removeRoomObserver()
    }
    
    private func updateDateSource(items: [PhotoModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<PhotoCollectionViewSection, PhotoModel>()
        snapshot.appendSections(PhotoCollectionViewSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    private func sortAndAddModels(photoModels: [PhotoModel]) -> [PhotoModel] {
        let sorted = sortPhotoModels(photoModels: photoModels)
        return addPhotoModels(photoModels: sorted)
    }
    
    private func sortPhotoModels(photoModels: [PhotoModel]) -> [PhotoModel] {
        return photoModels.sorted(by: {$0.currentPostion < $1.currentPostion})
    }
    
    private func addPhotoModels(photoModels: [PhotoModel]) -> [PhotoModel] {
        let sideCount = model.sideCount
        let totalCount = sideCount * sideCount
        let userId = UserDefaultsManager.userId
        var items: [PhotoModel] = []
        var currentIndex = 0
        for photoModel in photoModels {
            if currentIndex == photoModel.currentPostion {
                items.append(photoModel)
                currentIndex += 1
            } else {
                while currentIndex < photoModel.currentPostion {
                    let row = currentIndex / sideCount
                    let col = currentIndex % sideCount
                    let mockItem = PhotoModel(photoRoomId: model.photoRoomId, photoURL: nil, row: row, column: col, sideCount: sideCount, createdUserId: userId, rotatation: 0, isMirrored: false, isValid: false)
                    items.append(mockItem)
                    currentIndex += 1
                }
            }
        }
        while currentIndex < totalCount {
            let row = currentIndex / sideCount
            let col = currentIndex % sideCount
            let mockItem = PhotoModel(photoRoomId: model.photoRoomId, photoURL: nil, row: row, column: col, sideCount: sideCount, createdUserId: userId, rotatation: 0, isMirrored: false, isValid: false)
            items.append(mockItem)
            currentIndex += 1
        }
        return items
    }
    
    func bind(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell,
                let model = self?.sortedPhotoModels.value[indexPath.row] else { return nil }
            cell.configure(with: model)
            return cell
        })
        dataService.addRoomObserver(model: model)
        dataService
            .photoRoom
            .map({ room -> [PhotoModel] in
                return self.sortAndAddModels(photoModels: room?.photoModels ?? [])
            })
            .sink(receiveValue: { [weak self] items in
                self?.sortedPhotoModels.send(items)
            })
            .store(in: &cancellables)
        sortedPhotoModels
            .sink { [weak self] items in
                self?.updateDateSource(items: items)
            }
            .store(in: &cancellables)
    }
}
