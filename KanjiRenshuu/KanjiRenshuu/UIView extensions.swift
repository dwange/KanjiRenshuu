//
//  UIView extensions.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 03.02.2025.
//

import UIKit

extension UIView
{
    func addSubViews(_ views: [UIView]) {
        views.forEach {view in
        addSubview(view)}
    }
}
