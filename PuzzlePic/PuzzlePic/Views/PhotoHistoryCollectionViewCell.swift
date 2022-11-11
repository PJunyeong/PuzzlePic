//
//  PhotoHistoryCollectionViewCell.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import UIKit

enum PhotoHistoryCollectionViewSection: CaseIterable {
    case first
    case second
}

class PhotoHistoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoHistoryCollectionViewCell"
    private let joinedLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.addSubview(joinedLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageView)        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        joinedLabel.text = nil
    }
    
    func configure(with model: PhotoRoomModel) {
        titleLabel.text = model.title
    }
}
