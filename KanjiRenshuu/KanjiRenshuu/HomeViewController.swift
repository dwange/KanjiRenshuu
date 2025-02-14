//
//  ViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 21.01.2025.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    //MARK: - GUI Variables
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kanji Renshuu"
        label.font = UIFont(name: "Arial Bold", size: 35)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("Draw", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 25)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowColor = UIColor.systemGreen.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToSelectKanjiViewController), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("Match", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 25)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowColor = UIColor.systemCyan.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToMatchViewController), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Properties
    
    private let cornerRadius: CGFloat = 20
    private let buttonHeight: CGFloat = 80
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Private methods
    
    @objc private func goToSelectKanjiViewController() {
        navigationController?.pushViewController(SelectKanjiViewController(), animated: true)
        
    }
    
    @objc private func goToMatchViewController() {
        navigationController?.pushViewController(MatchViewController(), animated: true)
        
    }
    
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(firstButton)
        view.addSubview(secondButton)
        
        view.backgroundColor = .white
        
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        
        firstButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.leading.equalToSuperview().offset(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(firstButton.snp.top).offset(-80)
        }
        
        secondButton.snp.makeConstraints { make in
            make.top.equalTo(firstButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.width.equalTo(firstButton)
        }
    }
}

