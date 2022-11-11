//
//  SearchViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine
import CombineCocoa

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: nil)
        vc.searchBar.placeholder = "검색..."
        vc.searchBar.searchBarStyle = .minimal
//        vc.definesPresentationContext = true
        vc.automaticallyShowsCancelButton = false
        vc.hidesNavigationBarDuringPresentation = false
        return vc
    }()
    private let noSearchResultsView: UILabel = {
        let label = UILabel()
        label.text = "이런! 찾으시는 방이 없습니다.\n다른 이름으로 검색해 보세요."
        label.textAlignment = .center
        label.textColor = UIColor.theme.accent
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return collectionView
    }()
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        noSearchResultsView.frame = view.bounds
        noSearchResultsView.center = view.center
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(noSearchResultsView)
        navigationItem.titleView = searchController.searchBar
        navigationItem.backBarButtonItem?.title = ""
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        collectionView.delegate = self
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popToView))
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc private func popToView() {
        navigationController?.popViewController(animated: true)
    }
    
    private func toggleNoSearchResultsView(isHidden: Bool) {
        let inView = isHidden ? collectionView : noSearchResultsView
        let outView = isHidden ? noSearchResultsView : collectionView
        
        UIView.transition(with: inView, duration: 0.5, options: .transitionCrossDissolve) {
            inView.isHidden = false
            outView.isHidden = true
        }
    }
    
    private func bind() {
        viewModel.bind(collectionView: collectionView)
        viewModel
            .allPhotoRooms
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rooms in
                self?.toggleNoSearchResultsView(isHidden: !rooms.isEmpty)
            }
            .store(in: &cancellables)
        searchController
            .searchBar
            .textDidChangePublisher
            .compactMap({ $0 })
            .sink { [weak self] query in
                self?.viewModel.searchText.send(query)
            }
            .store(in: &cancellables)
    }
    
    private func presentPhotoRoomView(model: PhotoRoomModel) {
        let vc = PhotoRoomViewController(model: model)
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = model.title
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 2
        return CGSize(width: width, height: width)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.allPhotoRooms.value[indexPath.row]
        presentPhotoRoomView(model: model)
    }
}
