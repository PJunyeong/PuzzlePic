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
        contentView.backgroundColor = UIColor.theme.accent
    }
    
    func configure(with model: PhotoModel, row: Int, column: Int) {
        guard let url = model.photoURL else { return }
        download(with: url)
    }
    
    private func download(with url: URL) {
        var imageSubscription: AnyCancellable?
        imageSubscription = StorageManager
            .downloadData(with: url)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] data in
                let image = UIImage(data: data)
                self?.imageView.image = image
                imageSubscription?.cancel()
            }
    }
}
