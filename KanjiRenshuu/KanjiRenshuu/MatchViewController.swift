//
//  MatchViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 22.01.2025.
//

import UIKit
import SnapKit

class MatchViewController: UIViewController {
    
    //MARK: - GUI Variables
    
    private let containerView = UIView()
    
    private let leftStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 10
        return view
    }()
    
    private let rightStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 10
        return view
    }()
    
    private var leftButtons: [UIButton] = []
    private var rightButtons: [UIButton] = []
    
    //MARK: - Properties
    private var kanjiPairs: [(kanji: String, translation: String)] = []
    private var selectedKanji: UIButton?
    private var selectedTranslation: UIButton?
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let kanjiManager = KanjiManager()
        kanjiManager.fetchRandomKanjiPairs(count: 5) { [weak self] pairs in
            guard let self, let pairs else { return }
            self.kanjiPairs = pairs
            self.configureUI()
        }
    }
    
    //MARK: - Private methods
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.addSubViews([leftStack, rightStack])
        
        createButtonsForStacks()
        
        setupConstraints()
    }
    func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        leftStack.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        rightStack.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        for button in leftButtons + rightButtons {
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
    }
    private func createButtonsForStacks() {
        let shuffledTranslations = kanjiPairs.map { $0.translation }.shuffled()
        
        for i in 0..<kanjiPairs.count {
            let leftButton = createButton(title: kanjiPairs[i].kanji)
            let rightButton = createButton(title: shuffledTranslations[i])
            
            leftButtons.append(leftButton)
            rightButtons.append(rightButton)
            
            leftStack.addArrangedSubview(leftButton)
            rightStack.addArrangedSubview(rightButton)
        }
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if leftButtons.contains(sender) {
            selectedKanji = sender
        } else if rightButtons.contains(sender) {
            selectedTranslation = sender
        }
        
        if let kanji = selectedKanji, let translation = selectedTranslation {
            if isMatchingPair(kanji: kanji, translation: translation) {
                kanji.backgroundColor = .systemGreen
                translation.backgroundColor = .systemGreen
            } else {
                kanji.backgroundColor = .systemRed
                translation.backgroundColor = .systemRed
            }
            
            selectedKanji = nil
            selectedTranslation = nil
        }
    }
    
    private func isMatchingPair(kanji: UIButton, translation: UIButton) -> Bool {
        guard let kanjiText = kanji.title(for: .normal),
              let translationText = translation.title(for: .normal) else { return false }
        
        return kanjiPairs.contains { $0.kanji == kanjiText && $0.translation == translationText }
    }
}

