//
//  Color+Extensions.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import UIKit

extension UIColor {
    static let theme = ColorTheme()
}

struct ColorTheme {
    var accent: UIColor {
        guard let color = UIColor(named: "AccentColor") else { fatalError() }
        return color
    }
    var background: UIColor {
        guard let color = UIColor(named: "BackgroundColor") else { fatalError() }
        return color
    }
    var green: UIColor {
        guard let color = UIColor(named: "GreenColor") else { fatalError() }
        return color
    }
    var red: UIColor {
        guard let color = UIColor(named: "RedColor") else { fatalError() }
        return color
    }
    var secondaryText: UIColor {
        guard let color = UIColor(named: "SecondaryTextColor") else { fatalError() }
        return color
    }
}
