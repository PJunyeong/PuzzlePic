//
//  PhotoViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine
import CombineCocoa

class PhotoRoomViewController: UIViewController {
    private let viewModel: PhotoViewModel

    init(model: PhotoRoomModel) {
        self.viewModel = PhotoViewModel(model: model)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.model.title
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
