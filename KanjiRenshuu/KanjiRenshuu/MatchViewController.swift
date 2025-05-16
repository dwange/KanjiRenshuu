//
//  MatchViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 22.01.2025.
//

import UIKit
import SnapKit

class MatchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let matchView = MatchView()
    private let viewModel = MatchViewModel()
    
    private var kanjiLoadingView: KanjiLoadingView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBindings()
        setupViews()
        
        showKanjiLoadingAnimation()
        viewModel.fetchKanjiPairs()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        view.addSubview(matchView)
        matchView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func setupBindings() {
        viewModel.onDataUpdate = { [weak self] in
            guard let self = self else { return }
            self.matchView.configureButtons(kanjiPairs: self.viewModel.kanjiPairs)
            self.stopLoading()
        }
        
        matchView.onLeftButtonTapped = { [weak self] index in
            self?.viewModel.selectKanji(at: index)
        }
        
        matchView.onRightButtonTapped = { [weak self] index in
            self?.viewModel.selectTranslation(at: index)
        }
        
        viewModel.onMatchResult = { [weak self] isMatch, leftIndex, rightIndex in
            guard let self = self else { return }
            self.matchView.updateButtonColors(leftIndex: leftIndex, rightIndex: rightIndex, isMatch: isMatch)
        }
    }
    
    private func showKanjiLoadingAnimation() {
        kanjiLoadingView = KanjiLoadingView()
        view.addSubview(kanjiLoadingView)
        kanjiLoadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async {
            self.kanjiLoadingView.stop()
            self.kanjiLoadingView.removeFromSuperview()
        }
    }
}
