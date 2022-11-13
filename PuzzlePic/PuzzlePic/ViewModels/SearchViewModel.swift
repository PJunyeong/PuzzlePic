//
//  SearchViewModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import Combine
import UIKit

class SearchViewModel {
    let allPhotoRoomSearchs: CurrentValueSubject<[PhotoRoomSearchModel], Never> = .init([])
    let searchText: CurrentValueSubject<String, Never> = .init("")
    private let dataService: PhotoRoomsSearchDataManager
    private var dataSource: UICollectionViewDiffableDataSource<SearchCollectionViewSection, PhotoRoomSearchModel>!
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: PhotoRoomsSearchDataManager) {
        self.dataService = dataService
    }
    
    private func updateDateSource(items: [PhotoRoomSearchModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchCollectionViewSection, PhotoRoomSearchModel>()
        snapshot.appendSections(SearchCollectionViewSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func bind(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell,
                let model = self?.allPhotoRoomSearchs.value[indexPath.row] else { return nil }
            cell.configure(with: model)
            return cell
        })
        allPhotoRoomSearchs
            .sink { [weak self] items in
                self?.updateDateSource(items: items)
            }
            .store(in: &cancellables)
        searchText
            .combineLatest(dataService.allPhotoRoomSearchs)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .map(filterAndSortRooms)
            .sink { [weak self] rooms in
                self?.allPhotoRoomSearchs.send(rooms)
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortRooms(query: String, rooms: [PhotoRoomSearchModel]) -> [PhotoRoomSearchModel] {
        let filteredRooms = filterRooms(query: query, rooms: rooms)
        return sortRooms(rooms: filteredRooms)
    }
    
    private func filterRooms(query: String, rooms: [PhotoRoomSearchModel]) -> [PhotoRoomSearchModel] {
        guard !query.isEmpty else { return rooms }
        let lowerCasedQuery = query.lowercased()
        return rooms.filter({ $0.title.lowercased().contains(lowerCasedQuery) && !$0.isCompleted })
    }
    
    private func sortRooms(rooms: [PhotoRoomSearchModel]) -> [PhotoRoomSearchModel] {
        return rooms.sorted { first, second in
            return first.title < second.title
        }
    }

//    private func addMockData() {
//        var datas = [PhotoRoomModel]()
//        let userId = UserDefaultsManager.userId
//        for x in 0..<10 {
//            let title = "mock data_\(x)"
//            let data = PhotoRoomModel(title: title, createdUserId: userId, password: "password_\(x)", createdDate: Date().asString, photoTemplate: "", sideCount: 3, photoIds: [], joinedUserIds: [userId])
//            dataService.set(photoRoomModel: data)
//        }
//    }
}
