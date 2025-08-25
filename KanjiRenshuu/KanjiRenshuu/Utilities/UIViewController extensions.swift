//
//  UIViewController extensions.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 25/08/25.
//

import UIKit

extension UIViewController {
    func showDrawViewController(for kanjiObject: KanjiObject, kanjiGroup: [KanjiObject]? = nil) {
        let drawVC = DrawViewController()
        drawVC.viewModel.kanji = kanjiObject.kanji.character
        drawVC.viewModel.kanjiGroup = kanjiGroup ?? [kanjiObject]
        
        if let posterString = kanjiObject.kanji.video.poster,
           let posterURL = URL(string: posterString) {
            drawVC.posterURL = posterURL
        }
        
        if let videoString = kanjiObject.kanji.video.mp4,
           let videoURL = URL(string: videoString) {
            drawVC.videoURL = videoURL
        }
        
        navigationController?.pushViewController(drawVC, animated: true)
    }
}
