//
//  PhotoHistoryViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine

class PhotoHistoryViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoHistoryCollectionViewCell.self, forCellWithReuseIdentifier: PhotoHistoryCollectionViewCell.identifier)
        return collectionView
    }()
    private let viewModel: PhotoHistoryViewModel
    
    init(dataService: PhotoRoomsDataManager) {
        self.viewModel = PhotoHistoryViewModel(dataService: dataService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        setNavigationBar()
    }
    
    private func bind() {
        viewModel.bind(collectionView: collectionView)
    }
    
    private func setNavigationBar() {
        let searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        let settingButton = UIButton(type: .custom)
        settingButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        settingButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingButton.addTarget(self, action: #selector(settingButtonDidTap), for: .touchUpInside)
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        navigationItem.setRightBarButtonItems([settingBarButton, searchBarButton], animated: false)
    }
    
    @objc private func searchButtonDidTap() {
        let searchVC = SearchViewController(dataService: viewModel.dataService)
        navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @objc private func settingButtonDidTap() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
}

extension PhotoHistoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
}
