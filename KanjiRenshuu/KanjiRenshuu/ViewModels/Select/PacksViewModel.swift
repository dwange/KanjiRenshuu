//
//  PacksViewModel.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 21/08/25.
//

import Foundation

final class PacksViewModel {
    
    private(set) var packs: [PackModel] = []
    
    func loadPacks() {
        if let url = Bundle.main.url(forResource: "packs", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoded = try JSONDecoder().decode([PackModel].self, from: data)
                self.packs = decoded
                print("✅ Loaded packs: \(decoded.map { $0.title })")
            } catch {
                print("❌ Error decoding packs.json: \(error)")
            }
        } else {
            print("⚠️ Could not find packs.json in bundle")
        }
    }
    
}

