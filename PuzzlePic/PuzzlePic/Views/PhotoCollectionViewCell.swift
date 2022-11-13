//
//  PhotoCollectionViewCell.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import UIKit
import Combine

enum PhotoCollectionViewSection: CaseIterable {
    case first
}

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    private func setUI() {
        contentView.addSubview(imageView)
    }
    
    func configure(with model: PhotoModel) {
        if let url = model.photoURL {
            handleURL(with: url)
        } else {
            imageView.image = UIImage(systemName: "\(model.currentPostion).circle")
        }
    }
    
    private func handleURL(with url: URL) {
        if let image = NSCacheManager.shared.get(name: url.absoluteString) {
            imageView.image = image
        } else {
            var imageSubscription: AnyCancellable?
            imageSubscription = LocalFileManager
                .downloadData(with: url)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        print(error.localizedDescription)
                        imageSubscription?.cancel()
                        self?.networkDownload(with: url)
                    }
                } receiveValue: { [weak self] data in
                    if let image = UIImage(data: data) {
                        self?.imageView.image = image
                        NSCacheManager.shared.save(image: image, name: url.absoluteString)
                    }
                    imageSubscription?.cancel()
                }
        }
    }
    
    private func networkDownload(with url: URL) {
        var imageSubscription: AnyCancellable?
//        imageSubscription = StorageManager
//            .downloadData(with: url)
//            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] data in
//                let image = UIImage(data: data)
//                self?.imageView.image = image
//                imageSubscription?.cancel()
//            }
        imageSubscription = NetworkingManager
            .download(with: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] data in
                if let image = UIImage(data: data) {
                    self?.imageView.image = image
                    NSCacheManager.shared.save(image: image, name: url.absoluteString)
                }
                imageSubscription?.cancel()
            })
    }
}
