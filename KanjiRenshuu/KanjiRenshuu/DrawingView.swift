//
//  DrawingView.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 11.02.2025.
//

import UIKit
import SwiftSVG

class DrawingView: UIView {
    
    //MARK: - Properties
    
    private var strokes: [[CGPoint]] = [[]]
    private var svgView: UIView?
    
    //MARK: - Initializers
    
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
        
        guard let fileName = mapping[kanji]?.first else {
            print("SVG not found for kanji: \(kanji)")
            return
        }
        
        guard let url = Bundle.main.url(forResource: "KanjiSVG/\(fileName)", withExtension: nil) else {
            print("Could not find SVG file: \(fileName) in bundle.")
            return
        }
            
            let svgView = UIView(SVGURL: url)
            svgView.alpha = 0.2
            
            svgView.contentMode = .scaleAspectFit
            addSubview(svgView)
            self.svgView = svgView

            // Layout SVG View
            svgView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                svgView.centerXAnchor.constraint(equalTo: centerXAnchor),
                svgView.centerYAnchor.constraint(equalTo: centerYAnchor),
                svgView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
                svgView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
            ])
        }
    
    //MARK: -  Methods
    
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
        context.setLineWidth(6)
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
}
