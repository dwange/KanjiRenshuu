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
    
    private var selectedLeftIndex: Int?
    private var selectedRightIndex: Int?
    
    
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
            selectedLeftIndex = sender.tag
            highlightButton(sender, asSelected: true)
            onLeftButtonTapped?(sender.tag)
        } else if rightButtons.contains(sender) {
            selectedRightIndex = sender.tag
            onRightButtonTapped?(sender.tag)
        }
    }
    
    private func highlightButton(_ button: UIButton, asSelected: Bool) {
        button.backgroundColor = asSelected ? .systemGreen : .white
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
    
    func updateButtonColors(kanji: String, translation: String, isMatch: Bool) {
        guard let leftButton = button(for: kanji, inLeft: true),
              let rightButton = button(for: translation, inLeft: false) else { return }
        
        if isMatch {
            leftButton.backgroundColor = .systemGreen
            rightButton.backgroundColor = .systemGreen
            UIView.animate(withDuration: 0.3) {
                leftButton.alpha = 0.5
                rightButton.alpha = 0.5
            }
            leftButton.isEnabled = false
            rightButton.isEnabled = false
        } else {
            rightButton.backgroundColor = .systemRed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                leftButton.backgroundColor = .white
                rightButton.backgroundColor = .white
            }
        }
    }
    
    
    func button(for title: String, inLeft: Bool) -> UIButton? {
        let buttons = inLeft ? leftButtons : rightButtons
        return buttons.first(where: { $0.title(for: .normal) == title })
    }
    
    
    func resetButtonColors() {
        for button in (leftButtons + rightButtons) {
            if button.isEnabled {
                button.backgroundColor = .white
                button.alpha = 1.0
            }
        }
    }
}
