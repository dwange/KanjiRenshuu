//
//  KanjiSVGLoader.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 23/05/25.
//

import Foundation
import SVGKit

final class KanjiSVGLoader {
    
    static let shared = KanjiSVGLoader()

    private let cache = NSCache<NSString, SVGKImage>()

    init() {}

    func loadStrokes(for kanjiObject: KanjiObject, completion: @escaping ([SVGKImage]) -> Void) {
        let urls = kanjiObject.kanji.strokes.images.compactMap { URL(string: $0) }
        var svgImages: [SVGKImage] = Array(repeating: SVGKImage(), count: urls.count)
        let group = DispatchGroup()

        for (index, url) in urls.enumerated() {
            group.enter()

            if let cached = cache.object(forKey: url.absoluteString as NSString) {
                svgImages[index] = cached
                group.leave()
            } else {
                URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                    defer { group.leave() }
                    guard let data = data, error == nil else {
                        print("Error loading SVG from: \(url)")
                        return
                    }
                    if let svgImage = SVGKImage(data: data) {
                        self?.cache.setObject(svgImage, forKey: url.absoluteString as NSString)
                        svgImages[index] = svgImage
                    }
                }.resume()
            }
        }

        group.notify(queue: .main) {
            let filtered = svgImages.filter { $0.domDocument != nil }
            completion(filtered)
        }
    }
}

