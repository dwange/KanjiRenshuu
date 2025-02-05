//
//  KanjiManager.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import Foundation

class KanjiManager: ObservableObject {
    
    @Published var kanjiData = [KanjiObject]()
    let allKanjiURL = "https://kanjiapi.dev/v1/kanji/all"

    internal func fetchAllKanji(completion: @escaping ([KanjiObject]) -> Void) {
        if let url = URL(string: allKanjiURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Did fail with error: \(error!)")
                    return
                }
                if let safeData = data {
                    do {
                        let kanjiList = try JSONDecoder().decode([String].self, from: safeData)
                        self.fetchKanjiDetails(for: kanjiList, completion: completion)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    private func fetchKanjiDetails(for kanjiList: [String], completion: @escaping ([KanjiObject]) -> Void) {
        let group = DispatchGroup()
        var detailedKanjiList = [KanjiObject]()
        
        for kanji in kanjiList.prefix(20) {
            group.enter()
            let urlString = "https://kanjiapi.dev/v1/kanji/\(kanji)"
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    defer { group.leave() }
                    if error != nil {
                        print("Did fail with error: \(error!)")
                        return
                    }
                    if let safeData = data {
                        let decoder = JSONDecoder()
                        do {
                            let kanjiObject = try decoder.decode(KanjiObject.self, from: safeData)
                            DispatchQueue.main.async {
                                detailedKanjiList.append(kanjiObject)
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
                task.resume()
            }
        }
        
        group.notify(queue: .main) {
            completion(detailedKanjiList)
        }
    }
}
