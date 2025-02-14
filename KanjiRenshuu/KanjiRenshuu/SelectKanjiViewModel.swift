//
//  SelectKanjiViewModel.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 14.02.2025.
//

import Foundation

final class SelectKanjiViewModel {
    
    // MARK: - Properties
    private let kanjiManager = KanjiManager()
    
    var sortedGrades: [Int?] = []
    var kanjiByGrade: [Int?: [KanjiObject]] = [:]
    
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Methods
    func fetchKanji() {
        kanjiManager.fetchAllKanji { [weak self] groupedKanji in
            guard let self = self else { return }
            
            let filteredGroupedKanji = groupedKanji.filter { $0.key != nil }
            self.kanjiByGrade = filteredGroupedKanji
            self.sortedGrades = filteredGroupedKanji.keys.sorted { $0 ?? Int.max < $1 ?? Int.max }
            
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
}
