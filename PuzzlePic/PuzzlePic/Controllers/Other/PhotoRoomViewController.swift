//
//  PhotoViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine
import CombineCocoa

class PhotoRoomViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel: PhotoRoomViewModel
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()

    init(model: PhotoRoomSearchModel, dataService: PhotoRoomsDataManager) {
        self.viewModel = PhotoRoomViewModel(model: model, dataService: dataService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
        viewModel.bind(collectionView: collectionView)
    }
    
    private func setNavigationBar() {
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissToSearchView), for: .touchUpInside)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        let rightButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc private func dismissToSearchView() {
        dismiss(animated: true)
    }
}

extension PhotoRoomViewController: UICollectionViewDelegate {
    
}

extension PhotoRoomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideCount = viewModel.model.sideCount
        
        let size = (Int(view.frame.width) - sideCount - 1) / sideCount
        return CGSize(width: size, height: size)
    }
}
