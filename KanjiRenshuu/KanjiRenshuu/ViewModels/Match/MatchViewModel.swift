//
//  MatchViewModel.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 16/05/25.
//

import Foundation

class MatchViewModel {
    
    // MARK: - Properties
    
    private(set) var kanjiPairs: [(kanji: String, translation: String)] = []
    
    var onDataUpdate: (() -> Void)?
    
    private var selectedKanji: String?
    private var selectedTranslation: String?
    
    var onMatchResult: ((Bool, String, String) -> Void)?
    
    // MARK: - Methods
    
    func fetchKanjiPairs(count: Int = 5) {
        KanjiManager().fetchRandomKanjiPairs(count: count) { [weak self] pairs in
            guard let self = self, let pairs = pairs else { return }
            self.kanjiPairs = pairs
            DispatchQueue.main.async {
                self.onDataUpdate?()
            }
        }
    }
    
    // MARK: - Methods (Select & Match)
    
    func selectKanji(_ kanji: String) {
        selectedKanji = kanji
        checkMatchIfPossible()
    }
    
    func selectTranslation(_ translation: String) {
        selectedTranslation = translation
        checkMatchIfPossible()
    }
    
    private func checkMatchIfPossible() {
        guard let kanji = selectedKanji, let translation = selectedTranslation else { return }
        
        let isMatch = kanjiPairs.contains(where: { $0.kanji == kanji && $0.translation == translation })
        
        onMatchResult?(isMatch, kanji, translation)
        
        selectedKanji = nil
        selectedTranslation = nil
    }
}

