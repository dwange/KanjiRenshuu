//
//  DrawViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 22.01.2025.
//

import UIKit
import SnapKit

class DrawViewController: UIViewController {
    
    //MARK: - GUI Variables
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let kanjiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 100)
        
        return label
    }()
    
    private let translationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("...", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(toggleTranslation), for: .touchUpInside)
        return button
    }()
    
    private let drawingView: DrawingView = {
        let view = DrawingView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 15
        button.setTitle("Retry".uppercased(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 15)
        button.layer.shadowColor = UIColor.systemCyan.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearDrawing), for: .touchUpInside)
        
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 15
        button.setTitle("Continue".uppercased(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 15)
        button.backgroundColor = .systemGreen
        button.layer.shadowColor = UIColor.systemGreen.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - Properties
    
    var kanji: String?
    private var kanjiDetailManager = KanjiDetailManager()
    
    private var isExpanded = false
    private var fullTranslationText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchKanjiData()
    }
    
    //MARK: - Private methods
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.addArrangedSubviews([kanjiLabel,
                                       translationStackView,
                                       drawingView,
                                       buttonStackView])
        translationStackView.addArrangedSubviews([translationLabel, moreButton])
        buttonStackView.addArrangedSubviews([retryButton, continueButton])
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        kanjiLabel.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.25)
        }
        
        translationStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        translationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-4)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        drawingView.snp.makeConstraints { make in
            make.top.equalTo(translationLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(stackView.snp.width).multipliedBy(0.75)
        }
        
    }
    
    @objc private func clearDrawing() {
        drawingView.clear()
    }
    
    @objc private func toggleTranslation() {
        if fullTranslationText.split(separator: ", ").count > 1 {
            let popupView = TranslationsPopUpView()
            popupView.translations = fullTranslationText.split(separator: ", ").dropFirst().map { String($0) }
            
            view.addSubview(popupView)
            popupView.translatesAutoresizingMaskIntoConstraints = false
            
            popupView.snp.makeConstraints { make in
                make.top.equalTo(moreButton.snp.bottom).offset(10)
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
                make.height.equalTo(200)
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func dismissPopup() {
        if let popupView = view.subviews.first(where: { $0 is TranslationsPopUpView }) {
            popupView.removeFromSuperview()
        }
    }
    
    func fetchKanjiData() {
        guard let kanji = kanji else { return }
        
        kanjiDetailManager.fetchKanjiDetails(kanji: kanji) { [weak self] kanjiObject in
            guard let self = self else { return }
            if let kanjiObject = kanjiObject {
                self.updateUI(with: kanjiObject)
            } else {
                self.showError()
            }
        }
    }
    
    func updateUI(with kanjiObject: KanjiObject) {
        kanjiLabel.text = kanjiObject.kanji
        fullTranslationText = kanjiObject.meanings.joined(separator: ", ")
        
        if let firstTranslation = kanjiObject.meanings.first {
            translationLabel.text = firstTranslation
        }
        
        moreButton.isHidden = kanjiObject.meanings.count <= 1
    }
    
    func showError() {
        // Handle error (e.g., show an alert to the user)
        kanjiLabel.text = "Error"
        translationLabel.text = "Unable to fetch data"
    }
}
