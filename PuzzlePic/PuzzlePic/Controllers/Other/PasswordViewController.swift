//
//  PasswordViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/12.
//

import UIKit
import Combine

protocol PasswordViewControllerDelegate: AnyObject {
    func passwordDidEntered(_ password: String, _ model: PhotoRoomModel)
}

class PasswordViewController: UIViewController {
    enum Input {
        case passwordDidVerified(isPassed: Bool)
    }
    weak var delegate: PasswordViewControllerDelegate?
    let model: PhotoRoomModel
    private var cancellables = Set<AnyCancellable>()
    
    init(model: PhotoRoomModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemRed
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        return textField
    }()
    
    func bind(input: AnyPublisher<Input, Never>) {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .passwordDidVerified(isPassed: let isPassed):
                    if !isPassed {
                        self?.textField.becomeFirstResponder()
                    }
                }
            }
            .store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.frame = CGRect(x: view.safeAreaInsets.left + 10, y: view.safeAreaInsets.top, width: view.frame.width - view.safeAreaInsets.left - view.safeAreaInsets.right - 20, height: 52)
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(textField)
        textField.delegate = self
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let text = textField.text?.trimmingCharacters(in: .whitespaces),
            !text.isEmpty else { return false }
        delegate?.passwordDidEntered(text, model)
        view.endEditing(true)
        return true
    }
}
