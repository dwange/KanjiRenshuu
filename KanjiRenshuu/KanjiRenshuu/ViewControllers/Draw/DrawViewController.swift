//
//  DrawViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 22.01.2025.
//

import UIKit
import SnapKit
import SVGKit

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
    
    private let kanjiInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let readingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let onReadingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .appText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let kunReadingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .appText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let strokesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let drawingView: DrawingView = {
        let view = DrawingView()
        view.backgroundColor = .appBackground
        
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
        button.backgroundColor = .appAccentAlt
        button.layer.cornerRadius = 15
        button.setTitle("Retry".uppercased(), for: .normal)
        button.setTitleColor(UIColor.appButtonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 15)
        button.layer.shadowColor = UIColor.appShadowMedium.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearDrawing), for: .touchUpInside)
        
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appPrimary
        button.layer.cornerRadius = 15
        button.setTitle("Continue".uppercased(), for: .normal)
        button.setTitleColor(UIColor.appButtonText, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 15)
        button.layer.shadowColor = UIColor.appShadowMedium.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showNextKanji), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Properties
    
    let viewModel = DrawKanjiViewModel()
    private var isExpanded = false
    
    var posterURL: URL?
    var videoURL: URL?
    
    private let kanjiVideoPlayerView = KanjiVideoPlayerView()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
        viewModel.fetchKanjiData()
        loadKanjiSVG()
        loadVideoPlayer()
        
    }
    
    //MARK: - Private methods
    
    func configureUI() {
        view.backgroundColor = .appBackground
        view.addSubview(stackView)
        
        kanjiInfoStackView.addArrangedSubviews([kanjiVideoPlayerView, readingsStackView])
        readingsStackView.addArrangedSubviews([onReadingsLabel, kunReadingsLabel])
        
        stackView.addArrangedSubviews([kanjiInfoStackView,
                                       translationLabel,
                                       strokesStackView,
                                       drawingView,
                                       buttonStackView])
        buttonStackView.addArrangedSubviews([retryButton,
                                             continueButton])
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        kanjiInfoStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
        
        kanjiVideoPlayerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        readingsStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        translationLabel.snp.makeConstraints { make in
            make.top.equalTo(kanjiInfoStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        strokesStackView.snp.makeConstraints { make in
            make.top.equalTo(translationLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(80)
        }
        
        drawingView.snp.makeConstraints { make in
            make.top.equalTo(strokesStackView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(stackView.snp.width).multipliedBy(0.75)
        }
        
    }
    
    private func loadKanjiSVG() {
        if let kanji = viewModel.getKanjiSVG() {
            drawingView.loadKanjiSVG(for: kanji, from: loadKanjiMapping())
        }
    }
    
    @objc private func clearDrawing() {
        drawingView.clear()
    }
    
    private func setupBindings() {
        viewModel.kanjiUpdated = { [weak self] kanjiObject in
            guard let self else { return }
            self.updateUI(with: kanjiObject)
        }
        
        viewModel.errorOccurred = { [weak self] in
            guard let self else { return }
            self.showError()
        }
    }
    
    private func loadVideoPlayer() {
        kanjiVideoPlayerView.posterURL = posterURL
        kanjiVideoPlayerView.videoURL = videoURL
    }
    
    @objc private func showNextKanji() {
        viewModel.getNextKanji()
    }
    
    private func updateUI(with kanjiObject: KanjiObject) {
        translationLabel.text = kanjiObject.kanji.meaning.english
        onReadingsLabel.text = "Onyomi: \(kanjiObject.kanji.onyomi.katakana ?? kanjiObject.kanji.onyomi.romaji)"
        kunReadingsLabel.text = "Kunyomi: \(kanjiObject.kanji.kunyomi.hiragana ?? kanjiObject.kanji.kunyomi.romaji)"
        self.updateKanjiVideoPlayer(with: kanjiObject)
        
        loadKanjiSVG()
    }
    
    private func showError() {
        translationLabel.text = "Unable to fetch data"
    }
    
    private func updateKanjiVideoPlayer(with kanjiObject: KanjiObject) {
        self.kanjiVideoPlayerView.posterURL = URL(string: kanjiObject.kanji.video.poster!)
        self.kanjiVideoPlayerView.videoURL = URL(string: kanjiObject.kanji.video.mp4!)
        self.kanjiVideoPlayerView.resetPlayerState()
    }
}
