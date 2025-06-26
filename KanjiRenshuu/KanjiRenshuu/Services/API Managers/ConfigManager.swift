//
//  ConfigManager.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 26/06/25.
//

import Foundation

class ConfigManager {
    static let shared = ConfigManager()
    
    private var config: [String: Any]?
    
    private init() {
        if let url = Bundle.main.url(forResource: "KanjiRenshuuConfig", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            self.config = config
        }
    }

    var apiKey: String? {
        return config?["KANJI_ALIVE_API_KEY"] as? String
    }
}
