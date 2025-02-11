//
//  DrawingView.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 11.02.2025.
//

import UIKit

class DrawingView: UIView {
    
    //MARK: - Properties
    
    private var strokes: [[CGPoint]] = [[]]
    
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
