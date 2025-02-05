//
//  KanjiDetailsManager.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import Foundation

class KanjiDetailManager {
    
    let kanjiURL = "https://kanjiapi.dev/v1/kanji/"
 
    func fetchKanjiDetails(kanji: String, completion: @escaping (KanjiObject?) -> Void) {
        let urlString = "\(kanjiURL)\(kanji)"
        performDetailsRequest(with: urlString, completion: completion)
        print(urlString)
    }
    
    func performDetailsRequest(with urlString: String, completion: @escaping (KanjiObject?) -> Void) {
        
        if let url = URL(string: urlString) {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Did fail with error")
                    return
                }
                
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let decodedData = try decoder.decode(KanjiObject.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
    }
}
