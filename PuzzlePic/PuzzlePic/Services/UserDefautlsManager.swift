//
//  UserDefautlsManager.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

class UserDefaultsManager {
    static var userId: String? {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return nil }
        return userId
    }
}
