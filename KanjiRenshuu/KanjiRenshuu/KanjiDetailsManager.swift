//
//  KanjiDetailsManager.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import Foundation

class KanjiDetailManager: KanjiAPIProtocol {
    
    let kanjiURL = "https://kanjialive-api.p.rapidapi.com/api/public/kanji/"
 
    func fetchKanjiDetails(kanji: String, completion: @escaping (KanjiObject?) -> Void) {
        let urlString = "\(kanjiURL)\(kanji)"
        fetchKanjiData(from: urlString, completion: completion)
    }
}
