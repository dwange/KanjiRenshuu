//
//  KanjiManager.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import Foundation

protocol KanjiAPIProtocol {}

class KanjiManager: KanjiAPIProtocol {
    
    var kanjiData = [KanjiObject]()
    let allKanjiURL = "https://kanjialive-api.p.rapidapi.com/api/public/kanji/all"
    
    func fetchAllKanji(completion: @escaping ([Int?: [KanjiObject]]) -> Void) {
        fetchKanjiData(from: allKanjiURL) { (kanjiList: [KanjiObject]?) in
            guard let kanjiList else {
                completion([:])
                return
            }

            let groupedKanji = Dictionary(grouping: kanjiList, by: {$0.grade })
            completion(groupedKanji)
        }
    }
}

//MARK: - KanjiAPI Protocol extension

extension KanjiAPIProtocol {
    
    func fetchKanjiData<T: Decodable>(from urlString: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        request.allHTTPHeaderFields = [
            "x-rapidapi-key": "a87b94926dmshc6de706fbe6f731p10a78ajsnbadc85bc3bc0",
            "x-rapidapi-host": "kanjialive-api.p.rapidapi.com"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Did fail with error: \(error!)")
                completion(nil)
                return
            }

            guard let safeData = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: safeData)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
