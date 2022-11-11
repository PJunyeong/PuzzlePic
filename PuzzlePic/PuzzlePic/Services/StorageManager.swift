//
//  StorageManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import FirebaseStorage
import Combine

class StorageManager {
    private static let storage = Storage.storage()
    private static let maxSize: Int64 = 10 * 1024 * 1024
    static func uploadData(with id: String, data: Data, contentType: PhotoType, pathRoot: PhotoPathRoot) -> AnyPublisher<URL, Error> {
        let metadata = StorageMetadata()
        metadata.contentType = contentType.rawValue
        let pathString = "/\(contentType.rawValue)/\(pathRoot.rawValue)/\(id)"
        return Future { promise in
            storage
                .reference()
                .child(pathString)
                .putData(data, metadata: metadata) { _, error in
                    if let error = error {
                        print(error.localizedDescription)
                        promise(.failure(error))
                    } else {
                        storage.reference().downloadURL { result in
                            switch result {
                            case .failure(let error):
                                print(error.localizedDescription)
                                promise(.failure(error))
                            case .success(let url):
                                promise(.success(url))
                            }
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    static func downloadData(with url: URL) -> AnyPublisher<Data, Error> {
        return Future { promise in
            storage.reference(forURL: url.absoluteString).getData(maxSize: maxSize) { result in
                switch result {
                case .success(let data): promise(.success(data))
                case .failure(let error): promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
