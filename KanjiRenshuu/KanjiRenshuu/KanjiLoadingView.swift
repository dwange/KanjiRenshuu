//
//  Untitled.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 16/05/25.
//

import UIKit
import SVGKit
import SnapKit

class KanjiLoadingView: UIView {
    
    // MARK: - Properties
    
    private var strokeImageViews: [SVGKFastImageView] = []
    private var currentStrokeIndex = 0

    private let totalStrokes = 14
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStrokes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStrokes()
    }
    
    // MARK: - Private methods
    
    private func setupStrokes() {
        strokeImageViews.forEach { $0.removeFromSuperview() }
        strokeImageViews = []
        currentStrokeIndex = 0
        
        for i in 1...totalStrokes {
            let filename = "ren(shuu)_\(i)"
            guard let svgURL = Bundle.main.url(forResource: filename, withExtension: "svg"),
                  let svgImage = SVGKImage(contentsOf: svgURL) else {
                print("❌ Failed to load SVG file: \(filename).svg")
                continue
            }
            if let imageView = SVGKFastImageView(svgkImage: svgImage)
            {
                imageView.alpha = 0
                addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                    make.size.equalTo(150)
                }
                strokeImageViews.append(imageView)
            } else {
                print("Failed to show image")
            }
        }
        
        animateStrokes()
        setupBackgroundCircle()
    }
    
    private func addSimplePulseAnimation() {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 1.0
        pulse.fromValue = 1.0
        pulse.toValue = 1.05
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        layer.add(pulse, forKey: "pulse")
    }
    
    private func setupBackgroundCircle() {
        let circle = UIView()
        circle.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        circle.layer.cornerRadius = 75
        circle.layer.masksToBounds = true
        addSubview(circle)
        circle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sendSubviewToBack(circle)
    }
    
    // MARK: - Methods
    
    func animateStrokes() {
        for (index, strokeView) in strokeImageViews.enumerated() {
            strokeView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                UIView.animate(withDuration: 0.3) {
                    strokeView.alpha = 1
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(strokeImageViews.count) * 0.2 + 0.5) {
            self.resetStrokes()
            self.animateStrokes()
        }
    }
    
    func resetStrokes() {
        for strokeView in strokeImageViews {
            strokeView.alpha = 0
        }
    }
    
    func stop() {
        layer.removeAllAnimations()
    }
}
