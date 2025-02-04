//
//  KanjiDetailsManager.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import Foundation
import Combine

class KanjiDetailManager: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private var kanjiSubject = CurrentValueSubject<KanjiObject?, Never>(nil)  // Publisher
    
    let kanjiURL = "https://kanjiapi.dev/v1/kanji/"
    
    var kanjiPublisher: AnyPublisher<KanjiObject?, Never> {
            return kanjiSubject.eraseToAnyPublisher()
        }
    
    func fetchKanjiDetails(kanji: String) {
        let urlString = "\(kanjiURL)\(kanji)"
        performDetailsRequest(with: urlString)
        print(urlString)
    }
    
    func performDetailsRequest(with urlString: String) {
        
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
                            self.kanjiSubject.send(decodedData)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
}
