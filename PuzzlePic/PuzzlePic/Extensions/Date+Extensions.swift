//
//  Date+Extensions.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

extension Date {
    var asString: String {
        return DateFormatter.dateFormatter.string(from: self)
    }
}
