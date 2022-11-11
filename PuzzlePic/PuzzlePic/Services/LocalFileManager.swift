//
//  LocalFileManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import Combine

enum PhotoType: String {
    case jpeg = "images/jpeg"
    case png = "images/png"
}

enum PhotoPathRoot: String {
    case photoThumbnail
    case photoThumbnailCompleted
    case photoDetail
}

class LocalFileManager {
    private static let folderName = "/downloaded_photos"
    
    private static func getDocumentDirectoryPath() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private static func getPhotoDirectoryPath() -> URL? {
        guard let documentDir = getDocumentDirectoryPath() else { return nil }
        return documentDir.appendingPathComponent(folderName).absoluteURL
    }
    
    private static func getFilePath(id: String, contentType: PhotoType, pathRoot: PhotoPathRoot) -> URL? {
        guard let photoDir = getPhotoDirectoryPath() else { return nil}
        let pathString = "/\(contentType.rawValue)/\(pathRoot.rawValue)/\(id)"
        return photoDir.appendingPathComponent(pathString + ".json")
    }
    
    private static func createFolderIfNeeded() {
        guard let photoDirectory = getPhotoDirectoryPath() else { return }
        if !FileManager.default.fileExists(atPath: photoDirectory.relativePath) {
            do {
                try FileManager.default.createDirectory(atPath: photoDirectory.relativePath, withIntermediateDirectories: true, attributes: nil)
                print("Created Folder")
            } catch {
                print("Error Creating Folder")
                print(error.localizedDescription)
            }
        }
    }
    
    static func uploadData(with id: String, data: Data, contentType: PhotoType, pathRoot: PhotoPathRoot) -> AnyPublisher<URL, Error> {
        guard let fileDir = getFilePath(id: id, contentType: contentType, pathRoot: pathRoot) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return Future { promise in
            do  {
                try data.write(to: fileDir, options: .atomic)
                promise(.success(fileDir))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func downloadData(with url: URL) -> AnyPublisher<Data, Error> {
        return Future { promise in
            DispatchQueue.global(qos: .default).async {
                do {
                    let data = try Data(contentsOf: url)
                    promise(.success(data))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
