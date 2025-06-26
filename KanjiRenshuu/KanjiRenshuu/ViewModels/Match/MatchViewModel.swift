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
    var onMatchResult: ((Bool, Int, Int) -> Void)?
    
    private var selectedKanjiIndex: Int?
    private var selectedTranslationIndex: Int?
    
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
    
    func selectKanji(at index: Int) {
        selectedKanjiIndex = index
        checkMatchIfPossible()
    }
    
    func selectTranslation(at index: Int) {
        selectedTranslationIndex = index
        checkMatchIfPossible()
    }
    
    private func checkMatchIfPossible() {
        guard let kanjiIndex = selectedKanjiIndex,
              let translationIndex = selectedTranslationIndex else {
            return
        }
        
        let kanji = kanjiPairs[kanjiIndex].kanji
        let translation = kanjiPairs[translationIndex].translation
        
        if kanjiPairs.contains(where: { $0.kanji == kanji && $0.translation == translation }) {
            onMatchResult?(true, kanjiIndex, translationIndex)
        } else {
            onMatchResult?(false, kanjiIndex, translationIndex)
        }
        
        selectedKanjiIndex = nil
        selectedTranslationIndex = nil
    }
}

