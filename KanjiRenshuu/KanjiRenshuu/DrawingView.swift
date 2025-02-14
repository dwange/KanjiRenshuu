//
//  DrawingView.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 11.02.2025.
//

import UIKit
import SVGKit
import SnapKit

class DrawingView: UIView {
    
    // MARK: - Properties
    
    private var strokes: [[CGPoint]] = [[]]
    private var svgView: SVGKImageView?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        isUserInteractionEnabled = true
    }
    
    // MARK: - SVG Loading
    
    func loadKanjiSVG(for kanji: String?, from mapping: [String: [String]]) {
        guard let kanji = kanji else {
            print("Kanji is nil.")
            return
        }
        
        guard let fileName = findSvgFileName(for: kanji, in: mapping) else {
            print("SVG not found for kanji: \(kanji)")
            return
        }
        
        guard let url = Bundle.main.url(forResource: "KanjiSVG/\(fileName)", withExtension: nil) else {
            print("Could not find SVG file: \(fileName) in bundle.")
            return
        }
        
        let svgImage = SVGKImage(contentsOf: url)
        
        let kanjiBlueprint = SVGKFastImageView(svgkImage: svgImage)
        kanjiBlueprint?.contentMode = .scaleAspectFit
        kanjiBlueprint?.translatesAutoresizingMaskIntoConstraints = false
        kanjiBlueprint?.alpha = 0.2
        
        svgView?.removeFromSuperview()
        
        if let svgImageView = kanjiBlueprint {
            self.addSubview(svgImageView)
            self.svgView = svgImageView
            
            svgImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        } else {
            print("Failed to create SVGKFastImageView from SVGKImage")
        }
        
        clear()
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        strokes.append([touchPoint])
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        strokes[strokes.count - 1].append(touchPoint)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(8)
        context.setLineCap(.round)
        
        for stroke in strokes {
            guard let firstPoint = stroke.first else { continue }
            context.move(to: firstPoint)
            for point in stroke.dropFirst() {
                context.addLine(to: point)
            }
        }
        
        context.strokePath()
    }
    
    func clear() {
        strokes = [[]]
        setNeedsDisplay()
    }
    
    // MARK: - Helper Methods
    
    private func findSvgFileName(for kanji: String, in mapping: [String: [String]]) -> String? {
        return mapping[kanji]?.first
    }
}
