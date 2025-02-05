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
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let drawingView: UIView = {
        let view = UIView()
        
        return view
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        fetchKanjiData()
    }
    
    //MARK: - Private methods
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubviews([kanjiLabel, translationLabel, drawingView, continueButton])
        setupConstraints()
    }
    
    func setupConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        kanjiLabel.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.25)
        }
        
        drawingView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).multipliedBy(0.5)
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(stackView.snp.width).multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(20)
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
        translationLabel.text = kanjiObject.meanings.joined(separator: ", ")
    }

    func showError() {
        // Handle error (e.g., show an alert to the user)
        kanjiLabel.text = "Error"
        translationLabel.text = "Unable to fetch data"
    }
}
