//
//  DrawViewModel.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 14.02.2025.
//

import Foundation

class DrawKanjiViewModel {
    
    // MARK: - Properties
    private let kanjiDetailManager = KanjiDetailManager()
    
    var kanji: String?
    var kanjiGroup: [KanjiObject] = []
    private var kanjiMapping = loadKanjiMapping()
    
    var kanjiUpdated: ((KanjiObject) -> Void)?
    var errorOccurred: (() -> Void)?
    
    var fullTranslationText: String = ""
    
    // MARK: - Methods
    
    func fetchKanjiData() {
        guard let kanji else { return }
        
        kanjiDetailManager.fetchKanjiDetails(kanji: kanji) { [weak self] kanjiObject in
            guard let self else { return }
            if let kanjiObject {
                self.fullTranslationText = kanjiObject.kanji.meaning.english
                self.kanjiUpdated?(kanjiObject)
            } else {
                self.errorOccurred?()
            }
            
        }
    }
    
    func getNextKanji() {
        guard !kanjiGroup.isEmpty else { return }
        let randomKanji = kanjiGroup.randomElement()
        kanji = randomKanji?.kanji.character
        fetchKanjiData()
    }
    
    func getKanjiSVG() -> String? {
        return kanji
    }
}
