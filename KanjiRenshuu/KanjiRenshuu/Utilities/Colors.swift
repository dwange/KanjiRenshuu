//
//  Colors.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 24/10/25.
//

import UIKit

extension UIColor {
    
    // MARK: - Core Palette
    static let appPrimary      = UIColor(red: 59/255, green: 178/255, blue: 115/255, alpha: 1.0)     // Emerald
    static let appSecondary    = UIColor(red: 28/255, green: 103/255, blue: 88/255, alpha: 1.0)    // Forest
    static let appAccent       = UIColor(red: 255/255, green: 209/255, blue: 102/255, alpha: 1.0)  // Warm yellow
    static let appBackground   = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)  // Light gray
    static let appText         = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)     // Charcoal text
    static let appError        = UIColor(red: 214/255, green: 69/255, blue: 69/255, alpha: 1.0)    // Gentle red
    
    // MARK: - Supporting Palette
    static let appAccentAlt    = UIColor(red: 80/255, green: 164/255, blue: 203/255, alpha: 1.0)   // Soft teal
    static let appPlaceholder  = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)  // Placeholder text
    static let appCardBackground = UIColor.white                                                   // Card background
    
    // MARK: - UI Elements
    static let appButtonText       = UIColor.white
    static let appButtonShadow     = UIColor.black.withAlphaComponent(0.12)
    
    static let appTabActive        = appPrimary
    static let appTabInactive      = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0) // Light gray tab
    
    static let appKanjiSquare      = UIColor.white
    static let appKanjiSquareBorder = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
    static let appKanjiSquareSelected = appAccentAlt
    static let appKanjiSquareCorrect = appAccent
    static let appKanjiSquareIncorrect = appError
    
    // MARK: - Drawing View
    static let appCanvasBackground = UIColor.white
    static let appVideoBorder      = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
    static let appRetryButton      = appError
    static let appContinueButton   = appPrimary
    
    // MARK: - Shadows
    static let appShadowLight      = UIColor.black.withAlphaComponent(0.08)
    static let appShadowMedium     = UIColor.black.withAlphaComponent(0.12)
    
    // MARK: - Optional Highlights
    static let appHighlightLight   = UIColor(red: 238/255, green: 250/255, blue: 240/255, alpha: 1.0) // very light green tint for subtle background highlights
    static let appHighlightWarm    = UIColor(red: 255/255, green: 244/255, blue: 214/255, alpha: 1.0) // light warm tint
}

