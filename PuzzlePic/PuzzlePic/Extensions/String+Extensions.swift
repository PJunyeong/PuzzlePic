//
//  String+Extensions.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation

extension String {
    var asDate: Date? {
        return DateFormatter.dateFormatter.date(from: self)
    }
}
