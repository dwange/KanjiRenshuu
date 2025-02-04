//
//  UIStackView extentions.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 03.02.2025.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)}
    }
}
