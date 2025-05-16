//
//  MatchView.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 16/05/25.
//

import UIKit
import SnapKit

class MatchView: UIView {
    
    // MARK: - GUI Variables
    
    let containerView = UIView()
    
    let leftStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 10
        return view
    }()
    
    let rightStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 10
        return view
    }()
    
    private(set) var leftButtons: [UIButton] = []
    private(set) var rightButtons: [UIButton] = []
    
    // MARK: - Properties
    
    var onLeftButtonTapped: ((Int) -> Void)?
    var onRightButtonTapped: ((Int) -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(leftStack)
        containerView.addSubview(rightStack)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftStack.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        rightStack.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    // MARK: - Private methods
    
    private func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if leftButtons.contains(sender) {
            onLeftButtonTapped?(sender.tag)
        } else if rightButtons.contains(sender) {
            onRightButtonTapped?(sender.tag)
        }
    }
     
    // MARK: - Methods
    
    func configureButtons(kanjiPairs: [(kanji: String, translation: String)]) {
        leftButtons.forEach { $0.removeFromSuperview() }
        rightButtons.forEach { $0.removeFromSuperview() }
        
        leftButtons.removeAll()
        rightButtons.removeAll()
        
        let shuffledTranslations = kanjiPairs.map { $0.translation }.shuffled()
        
        for i in 0..<kanjiPairs.count {
            let leftButton = createButton(title: kanjiPairs[i].kanji, tag: i)
            let rightButton = createButton(title: shuffledTranslations[i], tag: i)
            
            leftButtons.append(leftButton)
            rightButtons.append(rightButton)
            
            leftStack.addArrangedSubview(leftButton)
            rightStack.addArrangedSubview(rightButton)
        }
    }
    
    func updateButtonColors(leftIndex: Int, rightIndex: Int, isMatch: Bool) {
         let color: UIColor = isMatch ? .systemGreen : .systemRed
         
         guard leftIndex < leftButtons.count, rightIndex < rightButtons.count else { return }
         
         leftButtons[leftIndex].backgroundColor = color
         rightButtons[rightIndex].backgroundColor = color
     }
    
    func resetButtonColors() {
        (leftButtons + rightButtons).forEach {
            $0.backgroundColor = .white
        }
    }
}
